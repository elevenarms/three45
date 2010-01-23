class AddCreatedByToReferrals < ActiveRecord::Migration
  def self.up
    add_column :referrals, :created_by_user_id, :string, :limit => 36, :null => false, :references=>:users
  end

  def self.down
    remove_column :referrals, :created_by_user_id
  end
end
