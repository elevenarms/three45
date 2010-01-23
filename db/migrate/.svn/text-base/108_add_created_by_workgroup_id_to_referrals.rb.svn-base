class AddCreatedByWorkgroupIdToReferrals < ActiveRecord::Migration
  def self.up
    add_column :referrals, :created_by_workgroup_id, :string, :limit => 36, :references=>:workgroups
  end

  def self.down
    remove_column :referrals, :created_by_workgroup_id
  end
end
