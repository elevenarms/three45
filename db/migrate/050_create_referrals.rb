class CreateReferrals < ActiveRecord::Migration
  def self.up
    exists = Referral.table_exists? rescue false
    if !exists
      create_table :referrals, :id => false do |t|
        t.string  :id, :limit => 36, :null => false
        t.string  :referral_state_id, :limit => 36, :null => false
        t.string  :source_user_id, :limit => 36, :null => false, :references=>:users
        t.string  :source_workgroup_id, :limit => 36, :null => false, :references=>:workgroups
        t.string  :referral_reason_id, :limit => 36
        t.string  :cpt_code_id, :limit => 36
        t.string  :icd9_code_id, :limit => 36
        t.string  :target_id, :limit => 36, :references=>nil
        t.string  :target_type, :limit => 36
        t.text    :diagnosis_text
        t.text    :instruction_text
        t.boolean :source_action_requested_flag, :default=> false
        t.boolean :target_action_requested_flag, :default=> false
        t.timestamps
        t.datetime :deleted_at
      end

      puts "Setting primary key"
      execute "ALTER TABLE referrals ADD PRIMARY KEY (id)"
    end
  end

  def self.down
    exists = Referral.table_exists? rescue false
    if exists
      drop_table :referrals
    end
  end
end
