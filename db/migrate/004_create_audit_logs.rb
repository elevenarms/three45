class CreateAuditLogs < ActiveRecord::Migration
  def self.up
    exists = AuditLog.table_exists? rescue false
    if !exists
      create_table :audit_logs, :id => false do |t|
        t.string :id, :limit => 36, :null => false
        t.string :audit_category_id, :null => false, :limit => 36
        t.string :description
        t.string :billing_group_id, :limit => 36, :references=>nil
        t.string :user_id, :limit => 36, :references=>nil
        t.string :profile_id, :limit => 36, :references=>nil
        t.string :referral_id, :limit => 36, :references=>nil
        t.string :session_id, :references => nil
        t.string :ip_address
        t.timestamps
      end

      puts "Setting primary key"
      execute "ALTER TABLE audit_logs ADD PRIMARY KEY (id)"
    end
  end

  def self.down
    exists = AuditLog.table_exists? rescue false
    if exists
      drop_table :audit_logs
    end
  end
end
