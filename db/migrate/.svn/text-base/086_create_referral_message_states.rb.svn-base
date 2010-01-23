class CreateReferralMessageStates < ActiveRecord::Migration
  def self.up
    exists = ReferralMessageState.table_exists? rescue false
    if !exists
      create_table :referral_message_states, :id => false do |t|
        t.string :id, :limit => 36, :null => false
        t.string :name

        t.timestamps
      end

      puts "Setting primary key"
      execute "ALTER TABLE referral_message_states ADD PRIMARY KEY (id)"

      puts "Adding new FK to referral_messages"
      add_column :referral_messages, :referral_message_state_id, :string

      puts "Adding subject to referral_messages"
      add_column :referral_messages, :subject, :string
    end
  end

  def self.down
    exists = ReferralMessageState.table_exists? rescue false
    if exists
      drop_table :referral_message_states
    end
    remove_column :referral_messages, :referral_message_state_id
    remove_column :referral_messages, :subject
  end
end
