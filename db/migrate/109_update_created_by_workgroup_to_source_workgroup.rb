class UpdateCreatedByWorkgroupToSourceWorkgroup < ActiveRecord::Migration
  def self.up
    execute "update referrals r set created_by_workgroup_id = (select workgroup_id from referral_sources where referral_id = r.id order by created_at LIMIT 1)"
  end

  def self.down
    # nothing to do
  end
end
