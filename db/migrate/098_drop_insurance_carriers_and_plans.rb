class DropInsuranceCarriersAndPlans < ActiveRecord::Migration
  def self.up
    drop_table :insurance_carriers
    drop_table :insurance_carrier_plans
  end

  def self.down
    # not going to recreate
  end
end
