class DropReferralDiagnosisOptions < ActiveRecord::Migration
  def self.up
    drop_table :referral_diagnosis_options
  end

  def self.down
    # not going to undo this one
  end
end
