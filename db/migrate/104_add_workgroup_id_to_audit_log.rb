class AddWorkgroupIdToAuditLog < ActiveRecord::Migration
  def self.up
    remove_column :audit_logs, :billing_group_id
    remove_column :audit_logs, :ip_address # not required by the spec
    remove_column :audit_logs, :session_id # not required by the spec
    add_column    :audit_logs, :workgroup_id, :string, :limit => 36
    add_column    :audit_logs, :long_description, :text
  end

  def self.down
    add_column :audit_logs, :billing_group_id, :string, :limit => 36, :references=>nil
    add_column :audit_logs, :session_id, :string, :references => nil
    add_column :audit_logs, :ip_address, :string
    remove_column :audit_logs, :workgroup_id
    remove_column :audit_logs, :long_description
  end
end
