class AddMessageIdToFilesAndFaxes < ActiveRecord::Migration
  def self.up
    add_column :referral_files, :referral_message_id, :string, :limit=>36
    add_column :referral_faxes, :referral_message_id, :string, :limit=>36
    add_column :referral_messages, :viewed_at, :datetime
  end

  def self.down
    remove_column :referral_files, :referral_message_id
    remove_column :referral_faxes, :referral_message_id
    remove_column :referral_messages, :viewed_at
  end
end
