class CreateWorkgroupTypes < ActiveRecord::Migration
  def self.up
    exists = WorkgroupType.table_exists? rescue false
    if !exists
      create_table :workgroup_types, :id => false do |t|
        t.string :id, :limit => 36, :null => false
        t.string :name, :null => false
        t.timestamps
      end

      puts "Setting primary key"
      execute "ALTER TABLE workgroup_types ADD PRIMARY KEY (id)"

      puts "Installing some workgroup_types"

      execute "INSERT into workgroup_types (id, name) VALUES ('ppw','Physician Provider Workgroup')"
      execute "INSERT into workgroup_types (id, name) VALUES ('apw','Ancillary Provider Workgroup')"

    end
  end

  def self.down
    exists = WorkgroupType.table_exists? rescue false
    if exists
      drop_table :workgroup_types
    end
  end
end
