class AddReferralSourceOrTargetToReferralMessages < ActiveRecord::Migration
  def self.up
    add_column :referral_messages, :referral_source_or_target_id, :string, :limit=>36, :references=>nil
  end

  def self.down
    remove_column :referral_messages, :referral_source_or_target_id
  end
end
