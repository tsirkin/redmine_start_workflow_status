require File.dirname(__FILE__) + '/../test_helper'

class IssueStatusTest < ActiveSupport::TestCase
  fixtures :issue_statuses
  def ensure_multiple_default_statuses
    ### unfortunatly I couldn't make fixtures for plugin being loaded
    ### ,so i just update the right rows before the test is run
    default_issues_count = IssueStatus.
      find(:all,
           :conditions => "is_default = #{IssueStatus.connection.quoted_true}"
           ).count
    if default_issues_count < 2
      IssueStatus.all[0,2].each do |issue_status|
        next if issue_status.is_default
        issue_status.is_default = true
        issue_status.save
      end
    end
  end
  def test_multiple_default_issue_statuses
    ensure_multiple_default_statuses
    assert_operator 1 ,:<, IssueStatus.default.count
  end
end
