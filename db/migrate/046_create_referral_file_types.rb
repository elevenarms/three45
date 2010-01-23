class CreateReferralFileTypes < ActiveRecord::Migration
  def self.up
    exists = ReferralFileType.table_exists? rescue false
    if !exists
      create_table :referral_file_types, :id => false do |t|
        t.string :id, :limit => 36, :null => false
        t.string :name, :null => false
        t.timestamps
        t.datetime :deleted_at
      end

      puts "Setting primary key"
      execute "ALTER TABLE referral_file_types ADD PRIMARY KEY (id)"
    end
  end

  def self.down
    exists = ReferralFileType.table_exists? rescue false
    if exists
      drop_table :referral_file_types
    end
  end
end
