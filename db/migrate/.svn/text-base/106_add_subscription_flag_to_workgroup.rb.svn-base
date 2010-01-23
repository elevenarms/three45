class AddSubscriptionFlagToWorkgroup < ActiveRecord::Migration
  def self.up
    add_column :workgroups, :subscriber_flag, :boolean, :default=>false
  end

  def self.down
    remove_column :workgroups, :subscriber_flag
  end
end
