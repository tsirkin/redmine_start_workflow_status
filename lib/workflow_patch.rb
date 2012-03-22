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
require_dependency 'workflow'

module WorkflowPatch
  ### Desition needed - in the base class the :old_status is
  ### validated which makes it impossible to save old_status = -1
  ### ,the start workflow status.
  
  #validates_presence_of :role, :old_status, :new_status

  def self.included(base)
    unloadable
#    base.extend(ClassMethods)
#    base.send(:include, InstanceMethods)
    #debugger
    Workflow.const_set "START_STATUS_CODE",-1
    base.class_eval do
      #START_STATUS_CODE = -1
    end
  end
end
