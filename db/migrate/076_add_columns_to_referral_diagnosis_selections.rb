class AddColumnsToReferralDiagnosisSelections < ActiveRecord::Migration
  def self.up
    add_column :referral_diagnosis_selections, :tag_type_id, :string, :limit=>36
    add_column :referral_diagnosis_selections, :tag_id, :string, :limit=>36
    remove_column :referral_diagnosis_selections, :referral_diagnosis_option_id
  end

  def self.down
    remove_column :referral_diagnosis_selections, :tag_type_id
    remove_column :referral_diagnosis_selections, :tag_id
    # not going to re-add the dropped column above, as it was never used anyway
  end
end
