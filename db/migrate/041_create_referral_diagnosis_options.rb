class CreateReferralDiagnosisOptions < ActiveRecord::Migration
  def self.up
    exists = ReferralDiagnosisOption.table_exists? rescue false
    if !exists
      create_table :referral_diagnosis_options, :id => false do |t|
        t.string :id, :limit => 36, :null => false
        t.string :specialty_tag_id, :limit => 36, :null => false, :references=>:tags
        t.string :name, :null => false
        t.timestamps
        t.datetime :deleted_at
      end

      puts "Setting primary key"
      execute "ALTER TABLE referral_diagnosis_options ADD PRIMARY KEY (id)"
    end
  end

  def self.down
    drop_table :referral_request_types rescue puts "no old table to remove"
    exists = ReferralDiagnosisOption.table_exists? rescue false
    if exists
      drop_table :referral_diagnosis_options
    end
  end
end
