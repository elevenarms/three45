class AddPhoneToReferralPatient < ActiveRecord::Migration
  def self.up
    add_column :referral_patients, :phone, :string
  end

  def self.down
    remove_column :referral_patients, :phone
  end
end
