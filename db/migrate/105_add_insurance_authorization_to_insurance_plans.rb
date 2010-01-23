class AddInsuranceAuthorizationToInsurancePlans < ActiveRecord::Migration
  def self.up
    add_column :referral_insurance_plans, :authorization, :string
    add_column :referral_insurance_plans, :number_of_visits, :integer
    add_column :referral_insurance_plans, :expiration_date, :date
  end

  def self.down
    remove_column :referral_insurance_plans, :authorization
    remove_column :referral_insurance_plans, :number_of_visits
    remove_column :referral_insurance_plans, :expiration_date
  end
end
