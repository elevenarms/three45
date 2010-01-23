class AddToFromNamesToReferrals < ActiveRecord::Migration
  def self.up
    add_column :referrals, :from_name, :string
    add_column :referrals, :to_name, :string
  end

  def self.down
    remove_column :referrals, :from_name
    remove_column :referrals, :to_name
  end
end
