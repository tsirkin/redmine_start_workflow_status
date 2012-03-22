require_dependency 'issue_status'
# require 'pp'
# Patches Redmine's Issues Status dynamically.  Adds a new method
# is_new that means that the issue status can be marked as new
# in tracker.
module IssueStatusPatch
  def self.included(base) # :nodoc:
    unloadable
    ### looks like extend will not override already existing class
    ### methods but only add new ones .TODO: check this out i.e. if
    ### the extend will override already existsing class methods.
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)

    base.class_eval do
      base.after_save.delete_if{
        |callback| callback.method == :update_default
      }
      def base.default
        #find(:first, :conditions =>["is_default=?", true])
        find(:all, :conditions =>["is_default=?", true])[0]
      end 
    end
  end
  
  module ClassMethods
    # Returns the default status for new issues
    def all_defaults
      #find(:first, :conditions =>["is_default=?", true])
      find(:all, :conditions =>["is_default=?", true])
    end
  end
  
  module InstanceMethods
  end
end

# Add module to Issue
# moved to init.rb
# IssueStatus.send(:include, IssueStatusPatch)

