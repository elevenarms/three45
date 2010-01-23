class CreateReferralTargets < ActiveRecord::Migration
  def self.up
    exists = ReferralTarget.table_exists? rescue false
    if !exists
      create_table :referral_targets, :id => false do |t|
        t.string :id, :limit => 36, :null => false
        t.string :referral_id, :limit => 36, :null => false
        t.string :referral_target_state_id, :limit => 36, :null => false
        t.string :workgroup_id, :limit => 36, :null => false
        t.string :user_id, :limit => 36
        t.timestamps
        t.datetime :deleted_at
      end

      puts "Setting primary key"
      execute "ALTER TABLE referral_targets ADD PRIMARY KEY (id)"
    end
  end

  def self.down
    exists = ReferralTarget.table_exists? rescue false
    if exists
      drop_table :referral_targets
    end
  end
end
