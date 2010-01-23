class CreateWorkgroupUsers < ActiveRecord::Migration
  def self.up
    exists = WorkgroupUser.table_exists? rescue false
    if !exists
      transaction do
        create_table :workgroup_users, :id => false do |t|
          t.string :id, :limit => 36, :null => false
          t.string :workgroup_id, :limit => 36, :null => false, :references => nil
          t.string :user_id, :limit => 36, :null => false, :references => nil

          t.datetime :deleted_at
          t.timestamps
        end

        execute "ALTER TABLE workgroup_users ADD PRIMARY KEY (id)"
      end
    end
  end

  def self.down
    exists = WorkgroupUser.table_exists? rescue false
    if exists
      transaction do
        drop_table :workgroup_users
      end
    end
  end
end
