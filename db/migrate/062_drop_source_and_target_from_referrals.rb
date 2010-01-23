class DropSourceAndTargetFromReferrals < ActiveRecord::Migration
  def self.up
    remove_column :referrals, :source_user_id
    remove_column :referrals, :source_workgroup_id
    remove_column :referrals, :target_id
    remove_column :referrals, :target_type
  end

  def self.down
    # not gonna reverse it.. wouldn't be prudent...
  end
end
