class ChangeAddressesZipCodeColumn < ActiveRecord::Migration
  def self.up
    remove_column :addresses, :zip_plus_4
    add_column :addresses, :zip_code, :string
    add_column :addresses, :plus_four_code, :string
  end

  def self.down
    remove_column :addresses, :zip_code, :string
    remove_column :addresses, :plus_four_code, :string
    add_column :addresses, :zip_plus_4, :string
  end
end
