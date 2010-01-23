class RemoveFlagsFromReferrals < ActiveRecord::Migration
  def self.up
    remove_column :referrals, :source_action_requested_flag
    remove_column :referrals, :target_action_requested_flag
  end

  def self.down
    add_column :referrals, :source_action_requested_flag, :boolean
    add_column :referrals, :target_action_requested_flag, :boolean
  end
end
