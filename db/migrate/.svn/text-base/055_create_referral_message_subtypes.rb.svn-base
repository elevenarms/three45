class CreateReferralMessageSubtypes < ActiveRecord::Migration
  def self.up
    exists = ReferralMessageSubtype.table_exists? rescue false
    if !exists
      create_table :referral_message_subtypes, :id => false do |t|
        t.string  :id, :limit => 36, :null => false
        t.string  :referral_message_type_id, :limit => 36, :null => false
        t.string  :name, :null => false
        t.timestamps
        t.datetime :deleted_at
      end

      puts "Setting primary key"
      execute "ALTER TABLE referral_message_subtypes ADD PRIMARY KEY (id)"
    end
  end

  def self.down
    exists = ReferralMessageSubtype.table_exists? rescue false
    if exists
      drop_table :referral_message_subtypes
    end
  end
end
