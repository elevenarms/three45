class CreateReferralSources < ActiveRecord::Migration
  def self.up
    exists = ReferralSource.table_exists? rescue false
    if !exists
      create_table :referral_sources, :id => false do |t|
        t.string :id, :limit => 36, :null => false
        t.string :referral_id, :limit => 36, :null => false
        t.string :referral_source_state_id, :limit => 36, :null => false
        t.string :workgroup_id, :limit => 36, :null => false
        t.string :user_id, :limit => 36
        t.timestamps
        t.datetime :deleted_at
      end

      puts "Setting primary key"
      execute "ALTER TABLE referral_sources ADD PRIMARY KEY (id)"
    end
  end

  def self.down
    exists = ReferralSource.table_exists? rescue false
    if exists
      drop_table :referral_sources
    end
  end
end
