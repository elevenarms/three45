class CreateReferralMessageSubtypeSelections < ActiveRecord::Migration
  def self.up
    exists = ReferralMessageSubtypeSelection.table_exists? rescue false
    if !exists
      create_table :referral_message_subtype_selections, :id => false do |t|
        t.string  :id, :limit => 36, :null => false
        t.string  :referral_id, :limit => 36, :null => false
        t.string  :referral_message_id, :limit => 36, :null => false
        t.string  :referral_message_subtype_id, :limit => 36, :null => false
        t.timestamps
        t.datetime :deleted_at
      end

      puts "Setting primary key"
      execute "ALTER TABLE referral_message_subtype_selections ADD PRIMARY KEY (id)"
    end
  end

  def self.down
    exists = ReferralMessageSubtypeSelection.table_exists? rescue false
    if exists
      drop_table :referral_message_subtype_selections
    end
  end
end
