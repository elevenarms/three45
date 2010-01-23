class AddCreatedbyToProfileFriendships < ActiveRecord::Migration
  def self.up
    add_column :profile_friendships, :created_by_profile_id, :string, :limit=>36, :references=> :profiles
  end

  def self.down
    remove_column :profile_friendships, :created_by_profile_id
  end
end
