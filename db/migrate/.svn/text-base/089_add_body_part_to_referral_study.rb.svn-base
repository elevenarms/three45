class AddBodyPartToReferralStudy < ActiveRecord::Migration
  def self.up
    remove_column :referral_studies, :diagnostic_imaging_type_tag_id
    add_column :referral_studies, :study_modality_tag_id, :string, :limit=>36, :references=>:tags
    add_column :referral_studies, :body_part, :string
  end

  def self.down
    remove_column :referral_studies, :body_part
    remove_column :referral_studies, :study_modality_tag_id
    add_column :referral_studies, :diagnostic_imaging_type_tag_id, :string, :limit=>36, :references=>:tags
  end
end
