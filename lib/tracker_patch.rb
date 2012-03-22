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

module TrackerPatch 
  def self.included(base)
    base.class_eval do 
      has_many :issue_start_statuses ,:class_name => "IssueStartStatus" 
      has_many :workflow_start_statuses ,:class_name => "IssueStatus",
      :through => :issue_start_statuses ,:source => :issue_status ,:select => 'issue_start_statuses.role_id,issue_statuses.*'
      #named_scope :by_role_ids ,lambda {|role_ids| {conditions => }}
      #:joins => :issue_start_statuses
      # ,
      # :include => :issue_start_statuses
    end
  end
end
