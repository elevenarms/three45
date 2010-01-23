class UpdateAllWorkgroupsToSubscriberStatus < ActiveRecord::Migration
  def self.up
    execute("UPDATE workgroups set subscriber_flag = true")
  end

  def self.down
    # nothing to undo
  end
end
