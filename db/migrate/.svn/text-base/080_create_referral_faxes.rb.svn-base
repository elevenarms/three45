class CreateReferralFaxes < ActiveRecord::Migration
  def self.up
    exists = ReferralFax.table_exists? rescue false
    if !exists
      create_table :referral_faxes, :id => false do |t|
        t.string  :id, :limit => 36, :null => false
        t.string  :referral_id, :limit => 36, :null => false
        t.string  :referral_fax_state_id, :limit => 36, :null => false
        t.integer :page_count
        t.string  :comments
        t.string  :filename
        t.text    :error_details

        t.timestamps
        t.datetime :deleted_at
      end

      puts "Setting primary key"
      execute "ALTER TABLE referral_faxes ADD PRIMARY KEY (id)"
    end
  end

  def self.down
    exists = ReferralFax.table_exists? rescue false
    if exists
      drop_table :referral_faxes
    end
  end
end
