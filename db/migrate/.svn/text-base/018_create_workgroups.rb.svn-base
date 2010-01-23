class CreateWorkgroups < ActiveRecord::Migration
  def self.up
    exists = Workgroup.table_exists? rescue false
    if !exists
      transaction do
        create_table :workgroups, :id => false do |t|
          t.string :id, :limit => 36, :null => false
          t.string :workgroup_subtype_id, :limit => 36, :null => false, :references => nil
          t.string :workgroup_state_id, :limit => 36, :null => false, :references => nil
          t.string :workgroup_type_id, :limit => 36, :null => false, :references => nil

          t.string :name, :null => false
          t.string :description, :null => false
          t.string :subdomain, :null => false
          t.string :office_number, :null => false
          t.string :fax_number, :null => false

          t.datetime :deleted_at
          t.timestamps
        end

        execute "ALTER TABLE workgroups ADD PRIMARY KEY (id)"
      end
    end
  end

  def self.down
    exists = Workgroup.table_exists? rescue false
    if exists
      transaction do
        drop_table :workgroups
      end
    end
  end
end
