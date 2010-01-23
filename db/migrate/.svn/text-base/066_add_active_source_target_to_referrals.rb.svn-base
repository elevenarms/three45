class AddActiveSourceTargetToReferrals < ActiveRecord::Migration
  def self.up
    add_column :referrals, :active_source_id, :string, :limit=>36, :references=>:referral_sources
    add_column :referrals, :active_target_id, :string, :limit=>36, :references=>:referral_targets
  end

  def self.down
    remove_column :referrals, :active_source_id
    remove_column :referrals, :active_target_id
  end
end
