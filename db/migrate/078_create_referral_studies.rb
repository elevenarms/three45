class CreateReferralStudies < ActiveRecord::Migration
  def self.up
    exists = ReferralStudy.table_exists? rescue false
    if !exists
      create_table :referral_studies, :id => false do |t|
        t.string :id, :limit => 36, :null => false
        t.string :referral_id, :limit => 36, :null => false

        t.string :study_type_tag_id, :limit => 36, :null => false, :references=>:tags
        t.string :diagnostic_imaging_type_tag_id, :limit => 36, :null => false, :references=>:tags
        t.string :location_tag_id, :limit => 36, :null => false, :references=>:tags
        t.string :location_detail_tag_id, :limit => 36, :null => false, :references=>:tags

        t.text    :additional_comments

        t.timestamps
        t.datetime :deleted_at
      end

      puts "Setting primary key"
      execute "ALTER TABLE referral_studies ADD PRIMARY KEY (id)"
    end
  end

  def self.down
    exists = ReferralStudy.table_exists? rescue false
    if exists
      drop_table :referral_studies
    end
  end
end
