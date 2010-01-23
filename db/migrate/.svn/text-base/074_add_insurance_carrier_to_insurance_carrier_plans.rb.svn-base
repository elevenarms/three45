class AddInsuranceCarrierToInsuranceCarrierPlans < ActiveRecord::Migration
  def self.up
    add_column :insurance_carrier_plans, :insurance_carrier_id, :string, :limit=>36, :references=> :insurance_carriers
  end

  def self.down
    remove_column :insurance_carrier_plans, :insurance_carrier_id
  end
end
