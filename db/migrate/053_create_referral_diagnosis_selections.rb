class CreateReferralDiagnosisSelections < ActiveRecord::Migration
  def self.up
    exists = ReferralDiagnosisSelection.table_exists? rescue false
    if !exists
      create_table :referral_diagnosis_selections, :id => false do |t|
        t.string  :id, :limit => 36, :null => false
        t.string  :referral_id, :limit => 36, :null => false
        t.string  :referral_diagnosis_option_id, :limit => 36, :null => false, :references=>nil
        t.timestamps
        t.datetime :deleted_at
      end

      puts "Setting primary key"
      execute "ALTER TABLE referral_diagnosis_selections ADD PRIMARY KEY (id)"
    end
  end

  def self.down
    exists = ReferralDiagnosisSelection.table_exists? rescue false
    if exists
      drop_table :referral_diagnosis_selections
    end
  end
end
