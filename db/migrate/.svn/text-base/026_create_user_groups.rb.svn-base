class CreateUserGroups < ActiveRecord::Migration
  def self.up
    exists = UserGroup.table_exists? rescue false
    if !exists
      create_table :user_groups, :id => false do |t|
        t.string :id, :limit => 36, :null => false
        t.string :user_id, :limit => 36, :null => false
        t.string :group_id, :limit => 36, :null => false

        t.datetime :deleted_at
        t.timestamps
      end
      puts "Setting primary key"
      execute "ALTER TABLE user_groups ADD PRIMARY KEY (id)"
    end

  end

  def self.down
    exists = UserGroup.table_exists? rescue false
    if exists
      drop_table :user_groups
    end
  end
end
