class CreateReferralPatients < ActiveRecord::Migration
  def self.up
    exists = ReferralPatient.table_exists? rescue false
    if !exists
      create_table :referral_patients, :id => false do |t|
        t.string  :id, :limit => 36, :null => false
        t.string  :referral_id, :limit => 36, :null => false
        t.string  :first_name
        t.string  :middle_name
        t.string  :last_name
        t.string  :ssn
        t.date    :dob
        t.string  :gender, :limit=> 1
        t.timestamps
        t.datetime :deleted_at
      end

      puts "Setting primary key"
      execute "ALTER TABLE referral_patients ADD PRIMARY KEY (id)"
    end
  end

  def self.down
    exists = ReferralPatient.table_exists? rescue false
    if exists
      drop_table :referral_patients
    end
  end
end
