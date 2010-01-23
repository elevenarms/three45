class CreateProfileFriendships < ActiveRecord::Migration
  def self.up
    exists = ProfileFriendship.table_exists? rescue false
    if !exists
      create_table :profile_friendships, :id => false do |t|
        t.string :id, :limit => 36, :null => false
        t.string :source_profile_id, :limit => 36, :null => false, :references=>:profiles
        t.string :target_profile_id, :limit => 36, :null => false, :references=>:profiles
        t.timestamps
        t.datetime :deleted_at
      end

      puts "Setting primary key"
      execute "ALTER TABLE profile_friendships ADD PRIMARY KEY (id)"
    end
  end

  def self.down
    exists = ProfileFriendship.table_exists? rescue false
    if exists
      drop_table :profile_friendships
    end
  end
end
