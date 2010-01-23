class AddRequestFlag < ActiveRecord::Migration
  def self.up
    add_column :referrals, :request_flag, :boolean , :default => false
  end

  def self.down
    remove_column :referrals, :request_flag
  end
end
