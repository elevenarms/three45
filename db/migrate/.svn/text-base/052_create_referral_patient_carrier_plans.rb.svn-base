class CreateReferralPatientCarrierPlans < ActiveRecord::Migration
  def self.up
    exists = ReferralPatientCarrierPlan.table_exists? rescue false
    if !exists
      create_table :referral_patient_carrier_plans, :id => false do |t|
        t.string  :id, :limit => 36, :null => false
        t.string  :referral_patient_id, :limit => 36, :null => false
        t.string  :insurance_carrier_id, :limit => 36
        t.string  :insurance_carrier_plan_id, :limit => 36
        t.string  :policy_details
        t.timestamps
        t.datetime :deleted_at
      end

      puts "Setting primary key"
      execute "ALTER TABLE referral_patient_carrier_plans ADD PRIMARY KEY (id)"
    end
  end

  def self.down
    exists = ReferralPatientCarrierPlan.table_exists? rescue false
    if exists
      drop_table :referral_patient_carrier_plans
    end
  end
end
