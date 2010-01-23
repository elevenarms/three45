class CreateUserWorkgroupAddresses < ActiveRecord::Migration
  def self.up
    exists = UserWorkgroupAddress.table_exists? rescue false
    if !exists
      transaction do
        create_table :user_workgroup_addresses, :id => false do |t|
          t.string :id, :limit => 36, :null => false
          t.string :workgroup_address_id, :limit => 36, :null => false, :references => nil
          t.string :user_id, :limit => 36, :null => false, :references => nil

          t.datetime :deleted_at
          t.timestamps
        end

        execute "ALTER TABLE user_workgroup_addresses ADD PRIMARY KEY (id)"
      end
    end
  end

  def self.down
    exists = UserWorkgroupAddress.table_exists? rescue false
    if exists
      transaction do
        drop_table :user_workgroup_addresses
      end
    end
  end
end
