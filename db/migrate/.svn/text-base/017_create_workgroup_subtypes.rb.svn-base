class CreateWorkgroupSubtypes < ActiveRecord::Migration
  def self.up
    exists = WorkgroupSubtype.table_exists? rescue false
    if !exists
      transaction do
        create_table :workgroup_subtypes, :id => false do |t|
          t.string :id, :limit => 36, :null => false
          t.string :workgroup_type_id, :limit => 36, :null => false, :references => nil
          
          t.string :name, :null => false
          t.timestamps
        end

        execute "ALTER TABLE workgroup_subtypes ADD PRIMARY KEY (id)"
      end
    end
  end

  def self.down
    exists = WorkgroupSubtype.table_exists? rescue false
    if exists
      transaction do
        drop_table :workgroup_subtypes
      end
    end
  end
end
