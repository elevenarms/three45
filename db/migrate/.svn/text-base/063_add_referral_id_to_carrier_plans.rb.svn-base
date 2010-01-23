class AddReferralIdToCarrierPlans < ActiveRecord::Migration
  def self.up
    add_column :referral_patient_carrier_plans, :referral_id, :string, :limit => 36, :null => false
    remove_column :referral_patient_carrier_plans, :referral_patient_id
  end

  def self.down
    remove_column :referral_patient_carrier_plans, :referral_id
    add_column :referral_patient_carrier_plans, :referral_patient_id, :string, :limit => 36, :null => false
  end
end
