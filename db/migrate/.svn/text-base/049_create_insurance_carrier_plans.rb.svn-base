class CreateInsuranceCarrierPlans < ActiveRecord::Migration
  def self.up
    exists = InsuranceCarrierPlan.table_exists? rescue false
    if !exists
      create_table :insurance_carrier_plans, :id => false do |t|
        t.string :id, :limit => 36, :null => false
        t.string :name, :null => false
        t.timestamps
        t.datetime :deleted_at
      end

      puts "Setting primary key"
      execute "ALTER TABLE insurance_carrier_plans ADD PRIMARY KEY (id)"
    end
  end

  def self.down
    exists = InsuranceCarrierPlan.table_exists? rescue false
    if exists
      drop_table :insurance_carrier_plans
    end
  end
end
