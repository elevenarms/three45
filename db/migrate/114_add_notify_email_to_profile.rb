class AddNotifyEmailToProfile < ActiveRecord::Migration
  def self.up
    add_column :profiles, :notify_email, :string, :default=> ""
  end

  def self.down
    remove_column :profiles, :notify_email
  end
end
