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

module IssueStatusesControllerPatch 
  def self.included(base)
    unloadable
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)
    #debugger
  end
  module ClassMethods
  end
  module InstanceMethods
    def update_multiple
      @issue_statuses = IssueStatus.all()
      if params[:is_default].nil? || params[:is_closed].nil?
        flash[:error] = l(:no_default_closed_selected)
        redirect_to :action => 'index'
        return
      end
      begin
        IssueStatus.transaction do 
          ### TODO: check if there is at least one is_default & one is_closed
          @issue_statuses.each do |status|
            # debugger
            status.is_default = params[:is_default].include? status.id.to_s
            status.is_closed = params[:is_closed].include? status.id.to_s
            status.save! if status.changed?
          end
        end 
        flash[:notice] = l(:notice_successful_update)
      rescue Exception => ex
        logger.error ex
        flash[:error] = l(:error_update_statuses)
      end
      redirect_to :action => 'index'
    end
  end

  # def update
  #   @issue_status = IssueStatus.find(params[:id])
  #   if request.put? && @issue_status.update_attributes(params[:issue_status])
  #     flash[:notice] = l(:notice_successful_update)
  #     redirect_to :action => 'index'
  #   else
  #     render :action => 'edit'
  #   end
  # end

end
