class CreateProfiles < ActiveRecord::Migration
  def self.up
    exists = Profile.table_exists? rescue false
    if !exists
      create_table :profiles, :id => false do |t|
        t.string :id, :limit => 36, :null => false
        t.string :profile_type_id, :limit => 36, :null => false
        t.string :display_name, :null => false
        # MUTEX - either user or workgroup
        t.string :user_id, :limit => 36
        t.string :workgroup_id, :limit => 36
        t.timestamps
        t.datetime :deleted_at
      end

      puts "Setting primary key"
      execute "ALTER TABLE profiles ADD PRIMARY KEY (id)"
    end
  end

  def self.down
    exists = Profile.table_exists? rescue false
    if exists
      drop_table :profiles
    end
  end
end
