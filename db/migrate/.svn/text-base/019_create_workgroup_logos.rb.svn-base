class CreateWorkgroupLogos < ActiveRecord::Migration
  def self.up
    exists = WorkgroupLogo.table_exists? rescue false
    if !exists
      transaction do
        create_table :workgroup_logos, :id => false do |t|
          t.string :id, :limit => 36, :null => false
          t.string :workgroup_id, :limit => 36, :null => false, :references => nil

          t.string :path, :null => false
          t.integer :height
          t.integer :width
          
          t.datetime :deleted_at
          t.timestamps
        end

        execute "ALTER TABLE workgroup_logos ADD PRIMARY KEY (id)"
      end
    end
  end

  def self.down
    exists = WorkgroupLogo.table_exists? rescue false
    if exists
      transaction do
        drop_table :workgroup_logos
      end
    end
  end
end
