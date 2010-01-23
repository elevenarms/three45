class CreateReferralMessages < ActiveRecord::Migration
  def self.up
    exists = ReferralMessage.table_exists? rescue false
    if !exists
      create_table :referral_messages, :id => false do |t|
        t.string  :id, :limit => 36, :null => false
        t.string  :referral_id, :limit => 36, :null => false
        t.string  :referral_message_type_id, :limit => 36, :null => false
        t.text    :message_text
        t.datetime :response_required_by
        t.datetime :responded_at
        t.timestamps
        t.datetime :deleted_at
      end

      puts "Setting primary key"
      execute "ALTER TABLE referral_messages ADD PRIMARY KEY (id)"
    end
  end

  def self.down
    exists = ReferralMessage.table_exists? rescue false
    if exists
      drop_table :referral_messages
    end
  end
end
