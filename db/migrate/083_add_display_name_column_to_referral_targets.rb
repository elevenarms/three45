class AddDisplayNameColumnToReferralTargets < ActiveRecord::Migration
  def self.up
    add_column :referral_targets, :display_name, :string
  end

  def self.down
    remove_column :referral_targets, :display_name
  end
end
