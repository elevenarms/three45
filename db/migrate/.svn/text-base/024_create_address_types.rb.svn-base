class CreateAddressTypes < ActiveRecord::Migration
  def self.up
    exists = AddressType.table_exists? rescue false
    if !exists
      transaction do
        create_table :address_types, :id => false do |t|
          t.string :id, :limit => 36, :null => false
          
          t.string :name, :null => false

          t.datetime :deleted_at
          t.timestamps
        end

        execute "ALTER TABLE address_types ADD PRIMARY KEY (id)"
      end
    end
  end

  def self.down
    exists = AddressType.table_exists? rescue false
    if exists
      transaction do
        drop_table :address_types
      end
    end
  end
end
