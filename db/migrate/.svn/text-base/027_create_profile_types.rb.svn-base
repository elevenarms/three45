class CreateProfileTypes < ActiveRecord::Migration
  def self.up
    exists = ProfileType.table_exists? rescue false
    if !exists
      create_table :profile_types, :id => false do |t|
        t.string :id, :limit => 36, :null => false
        t.string :name, :null => false
        t.timestamps
      end

      puts "Setting primary key"
      execute "ALTER TABLE profile_types ADD PRIMARY KEY (id)"

      puts "Inserting default profile_types"
      execute "INSERT into profile_types (id, name, created_at, updated_at) values ('user','User Profile', now(), now())"
      execute "INSERT into profile_types (id, name, created_at, updated_at) values ('workgroup','Workgroup Profile', now(), now())"
    end
  end

  def self.down
    exists = ProfileType.table_exists? rescue false
    if exists
      drop_table :profile_types
    end
  end
end
