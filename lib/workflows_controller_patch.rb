# Redmine - project management software
# Copyright (C) 2006-2011  Jean-Philippe Lang
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
require_dependency 'workflows_controller'
require "pp"

module WorkflowsControllerPatch 
  def self.included(base)
    unloadable
#    base.extend(ClassMethods)
#    base.send(:include, InstanceMethods)
    #debugger
    base.class_eval do
      alias_method_chain :edit, :start_status
    end
  end

  def edit_with_start_status
    @role = Role.find_by_id(params[:role_id])
    @tracker = Tracker.find_by_id(params[:tracker_id])
    #workflow_start
    if request.post?
      #ActiveRecord.connection.
      #TODO: start transaction
      Workflow.destroy_all( ["role_id=? and tracker_id=?", @role.id, @tracker.id])
      (params[:issue_status] || []).each { |status_id, transitions|
        transitions.each { |new_status_id, options|
          author = options.is_a?(Array) && options.include?('author') && !options.include?('always')
          assignee = options.is_a?(Array) && options.include?('assignee') && !options.include?('always')
          logger.debug "-- Build new worklow old_status_id #{status_id} ,new_status_id #{new_status_id}"
          @role.workflows.build(:tracker_id => @tracker.id, 
                                :old_status_id => status_id, 
                                :new_status_id => new_status_id, 
                                :author => author, 
                                :assignee => assignee)
        }
      }
      logger.debug "-- Before Workflow Start save --"
      logger.debug "workflow_start "
      #logger.debug pp params
      IssueStartStatus.destroy_all(:tracker_id => @tracker.id,:role_id => @role.id)
      (params[:workflow_start] || []).each  do |start_status_id|
        issue_start_status=IssueStartStatus.new(:issue_status_id => start_status_id,
                                                :tracker_id => @tracker.id,
                                                :role_id => @role.id)
        issue_start_status.save
      end
      if @role.save
        flash[:notice] = l(:notice_successful_update)
        redirect_to :action => 'edit', :role_id => @role, :tracker_id => @tracker
        return
      else
        logger.debug "Errors"
        logger.debug YAML::dump(@role.errors)
      end
    end
    #@start_statuses=new Object()
    #
    @used_statuses_only = (params[:used_statuses_only] == '0' ? false : true)
    if @tracker
      #@start_statuses=IssueStartStatus.find_all_by_tracker_id(@tracker.id)
      @start_status_ids=IssueStartStatus.find(:all,
                                              :conditions => {:tracker_id => @tracker.id,:role_id => @role.id}).map do
        |ss| ss.issue_status_id 
      end
    end
    #logger.debug "Start status ids : "
    #logger.debug @start_status_ids
    #debugger
    if @tracker && @used_statuses_only && @tracker.issue_statuses.any?
      @statuses = @tracker.issue_statuses
    end
    @statuses ||= IssueStatus.find(:all, :order => 'position')
    #debugger
    if @tracker && @role && @statuses.any?
      workflows = Workflow.all(:conditions => {:role_id => @role.id, :tracker_id => @tracker.id})
      @workflows = {}
      @workflows['always'] = workflows.select {|w| !w.author && !w.assignee}
      @workflows['author'] = workflows.select {|w| w.author}
      @workflows['assignee'] = workflows.select {|w| w.assignee}
    end
  end
end
