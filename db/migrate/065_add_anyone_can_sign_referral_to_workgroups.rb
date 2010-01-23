class AddAnyoneCanSignReferralToWorkgroups < ActiveRecord::Migration
  def self.up
    add_column :workgroups, :anyone_can_sign_referral_flag, :boolean, :default=>true
  end

  def self.down
    remove_column :workgroups, :anyone_can_sign_referral_flag
  end
end
