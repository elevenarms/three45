class AddBlockedAtColumnsToProfileFriendships < ActiveRecord::Migration
  def self.up
    add_column :profile_friendships, :blocked_by_source_at, :datetime, :default=>nil
    add_column :profile_friendships, :blocked_by_target_at, :datetime, :default=>nil
  end

  def self.down
    remove_column :profile_friendships, :blocked_by_source_at
    remove_column :profile_friendships, :blocked_by_target_at
  end
end
