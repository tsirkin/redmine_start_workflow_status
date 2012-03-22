class IssueStartStatus < ActiveRecord::Base
  unloadable
  belongs_to :tracker
  belongs_to :issue_status
  validates_presence_of :issue_status_id, :tracker_id, :role_id
end
