class CreateIssueStartStatuses < ActiveRecord::Migration
  def self.up
    create_table :issue_start_statuses do |t|
      t.column :issue_status_id, :integer
      t.column :tracker_id, :integer
      t.column :role_id, :integer
    end
    add_index :issue_start_statuses, :issue_status_id, :name => "issue_start_statuses_issue_status_id_idx"
    add_index :issue_start_statuses, :tracker_id, :name => "issue_start_statuses_tracker_id_idx"
    add_index :issue_start_statuses, :role_id, :name => "issue_start_statuses_role_id_idx"
  end

  def self.down
    drop_table :issue_start_statuses
  end
end
