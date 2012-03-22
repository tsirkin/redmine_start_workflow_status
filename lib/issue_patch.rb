require_dependency 'issue'

# Patches Redmine's Issues Status dynamically.  Adds a new method
# is_new that means that the issue status can be marked as new
# in tracker.
module IssuePatch
  def self.included(base) # :nodoc:
    unloadable
    ### looks like extend will not override already existing class
    ### methods but only add new ones .TODO: check this out i.e. if
    ### the extend will override already existsing class methods.
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)
    #debugger
    base.class_eval do
      # base.after_initialize.delete_if do
      #   |callback| callback.method == :after_initialize
      # end
      # base.send(:after_initialize, :after_initialize_patched)
      #alias_method_chain :new_statuses_allowed_to, :multiple_defaults
    end
  end
  
  module ClassMethods
  end
  
  module InstanceMethods
    def new_statuses_for_new_issue(user)
      ### TODO: what if theere is no start status selected + debug why
      ### if the user is in the project (manager?) every possible
      ### status is included while issue creating.
      ### get the start statuses allowed for this role/tracker
      start_statuses=tracker.workflow_start_statuses
      role_ids=user.roles_for_project(project).collect(&:id)
      #debugger
      start_statuses=start_statuses.delete_if { |ss|
        !role_ids.include? ss.role_id
      }

      ### Use the default issue statuses as the start ones if there is
      ### no start ones set for the current tracker+role.
      start_statuses.empty? ?IssueStatus.all_defaults : start_statuses
    end
  end
end
