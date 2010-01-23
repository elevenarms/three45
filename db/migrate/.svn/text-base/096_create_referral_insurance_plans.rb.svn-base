class CreateReferralInsurancePlans < ActiveRecord::Migration
  def self.up
    exists = ReferralInsurancePlan.table_exists? rescue false
    if !exists
      create_table :referral_insurance_plans, :id => false do |t|
        t.string :id, :limit => 36, :null => false
        t.string :referral_id, :limit => 36, :null => false
        t.string :insurance_carrier_tag_id, :limit => 36, :references => :tags
        t.string :insurance_carrier_plan_tag_id, :limit => 36, :references => :tags
        t.string :policy_details

        t.datetime :deleted_at
        t.timestamps
      end

      puts "Setting primary key"
      execute "ALTER TABLE referral_insurance_plans ADD PRIMARY KEY (id)"
    end
  end

  def self.down
    exists = ReferralInsurancePlan.table_exists? rescue false
    if exists
      transaction do
        drop_table :referral_insurance_plans
      end
    end
  end
end
