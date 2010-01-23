class CreateAddresses < ActiveRecord::Migration
  def self.up
    exists = Address.table_exists? rescue false
    if !exists
      transaction do
        create_table :addresses, :id => false do |t|
          t.string :id, :limit => 36, :null => false
          
          t.string :street1, :null => false
          t.string :street2
          t.string :city, :null => false
          t.string :state, :null => false
          t.string :zip_plus_4, :null => false
          t.string :latlng
          
          t.datetime :deleted_at
          t.timestamps
        end

        execute "ALTER TABLE addresses ADD PRIMARY KEY (id)"
      end
    end
  end

  def self.down
    exists = Address.table_exists? rescue false
    if exists
      transaction do
        drop_table :addresses
      end
    end
  end
end
