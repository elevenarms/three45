class AddReplyToMessageIdToReferralMessages < ActiveRecord::Migration
  def self.up
    remove_column :referral_messages, :target_user_id
    add_column    :referral_messages, :reply_to_message_id, :string, :references=>:referral_messages

    remove_column :referral_messages, :source_user_id
    add_column    :referral_messages, :created_by_user_id, :string, :references=>:users
  end

  def self.down
    add_column :referral_messages, :target_user_id, :string, :references=>:users
    remove_column :referral_messages, :reply_to_message_id

    add_column    :referral_messages, :source_user_id, :string, :references=>:users
    remove_column :referral_messages, :created_by_user_id
  end
end
