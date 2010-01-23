class AddSourceTargetUserToReferralMessages < ActiveRecord::Migration
  def self.up
    add_column :referral_messages, :source_user_id, :string, :limit=>36, :references=>:users
    add_column :referral_messages, :target_user_id, :string, :limit=>36, :references=>:users
  end

  def self.down
    remove_column :referral_messages, :source_user_id
    remove_column :referral_messages, :target_user_id
  end
end
