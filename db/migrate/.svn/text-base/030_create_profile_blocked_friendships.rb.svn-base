class CreateProfileBlockedFriendships < ActiveRecord::Migration
  def self.up
    exists = ProfileBlockedFriendship.table_exists? rescue false
    if !exists
      create_table :profile_blocked_friendships, :id => false do |t|
        t.string :id, :limit => 36, :null => false
        t.string :source_profile_id, :limit => 36, :null => false, :references=>:profiles
        t.string :target_profile_id, :limit => 36, :null => false, :references=>:profiles
        t.timestamps
        t.datetime :deleted_at
      end

      puts "Setting primary key"
      execute "ALTER TABLE profile_blocked_friendships ADD PRIMARY KEY (id)"
    end
  end

  def self.down
    exists = ProfileBlockedFriendship.table_exists? rescue false
    if exists
      drop_table :profile_blocked_friendships
    end
  end
end
