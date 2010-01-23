class DropReferralPatientCarrierPlans < ActiveRecord::Migration
  def self.up
    drop_table :referral_patient_carrier_plans
  end

  def self.down
    # not going to undo
  end
end
