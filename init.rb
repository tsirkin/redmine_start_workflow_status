require 'dispatcher'
require 'redmine'
require_dependency 'issues_controller_patch'
require_dependency 'workflow_patch'
require_dependency 'workflows_controller_patch'
require_dependency 'tracker_patch'

Redmine::Plugin.register :redmine_start_workflow_status do
  name 'Redmine Start Workflow Status plugin'
  author 'Tsirkin Evgeny'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'
end


Dispatcher.to_prepare do
  Workflow.send(:include, WorkflowPatch)
  IssuesController.send(:include, IssuesControllerPatch)
  Issue.send(:include, IssuePatch)
  IssueStatus.send(:include, IssueStatusPatch)
  Tracker.send(:include, TrackerPatch)
  WorkflowsController.send(:include, WorkflowsControllerPatch)
  IssueStatusesController.send(:include, IssueStatusesControllerPatch)
end
