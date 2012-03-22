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

module IssuesControllerPatch
  def self.included(base)
    unloadable
#    base.extend(ClassMethods)
#    base.send(:include, InstanceMethods)
    #debugger
    base.class_eval do
      alias_method_chain :build_new_issue_from_params, :new_issue
    end
  end
  def build_new_issue_from_params_with_new_issue
    build_new_issue_from_params_without_new_issue
    if @issue.new_record?
      @allowed_statuses = @issue.new_statuses_for_new_issue(User.current)
    end
  end
end
