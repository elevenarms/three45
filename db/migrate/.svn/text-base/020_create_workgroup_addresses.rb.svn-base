class CreateWorkgroupAddresses < ActiveRecord::Migration
  def self.up
    exists = WorkgroupAddress.table_exists? rescue false
    if !exists
      transaction do
        create_table :workgroup_addresses, :id => false do |t|
          t.string :id, :limit => 36, :null => false
          t.string :workgroup_id, :limit => 36, :null => false, :references => nil
          t.string :address_id, :limit => 36, :null => false, :references => nil
          t.string :address_type_id, :limit => 36, :null => false, :references => nil

          t.datetime :deleted_at
          t.timestamps
        end

        execute "ALTER TABLE workgroup_addresses ADD PRIMARY KEY (id)"
      end
    end
  end

  def self.down
    exists = WorkgroupAddress.table_exists? rescue false
    if exists
      transaction do
        drop_table :workgroup_addresses
      end
    end
  end
end
