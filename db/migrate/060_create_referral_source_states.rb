class CreateReferralSourceStates < ActiveRecord::Migration
  def self.up
    exists = ReferralSourceState.table_exists? rescue false
    if !exists
      create_table :referral_source_states, :id => false do |t|
        t.string :id, :limit => 36, :null => false
        t.string :name, :null => false
        t.timestamps
        t.datetime :deleted_at
      end

      puts "Setting primary key"
      execute "ALTER TABLE referral_source_states ADD PRIMARY KEY (id)"
    end
  end

  def self.down
    exists = ReferralSourceState.table_exists? rescue false
    if exists
      drop_table :referral_source_states
    end
  end
end
