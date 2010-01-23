class CreateInsuranceCarriers < ActiveRecord::Migration
  def self.up
    exists = InsuranceCarrier.table_exists? rescue false
    if !exists
      create_table :insurance_carriers, :id => false do |t|
        t.string :id, :limit => 36, :null => false
        t.string :name, :null => false
        t.timestamps
        t.datetime :deleted_at
      end

      puts "Setting primary key"
      execute "ALTER TABLE insurance_carriers ADD PRIMARY KEY (id)"
    end
  end

  def self.down
    exists = InsuranceCarrier.table_exists? rescue false
    if exists
      drop_table :insurance_carriers
    end
  end
end
