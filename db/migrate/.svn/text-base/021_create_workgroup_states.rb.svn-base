class CreateWorkgroupStates < ActiveRecord::Migration
  def self.up
    exists = WorkgroupState.table_exists? rescue false
    if !exists
      transaction do
        create_table :workgroup_states, :id => false do |t|
          t.string :id, :limit => 36, :null => false
          
          t.string :name, :null => false
          t.timestamps
        end

        execute "ALTER TABLE workgroup_states ADD PRIMARY KEY (id)"

        execute "INSERT into workgroup_states (id, name) VALUES ('active','Active')"
        execute "INSERT into workgroup_states (id, name) VALUES ('deactivated','Deactivated')"
      end
    end
  end

  def self.down
    exists = WorkgroupState.table_exists? rescue false
    if exists
      transaction do
        drop_table :workgroup_states
      end
    end
  end
end
