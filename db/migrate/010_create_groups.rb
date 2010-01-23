class CreateGroups < ActiveRecord::Migration
  def self.up
    exists = Group.table_exists? rescue false
    if !exists
      create_table :groups, :id => false do |t|
        t.string :id, :limit => 36, :null => false
        t.string :workgroup_type_id, :limit => 36, :null => false
        t.string :name, :null => false
        t.timestamps
      end

      puts "Setting primary key"
      execute "ALTER TABLE groups ADD PRIMARY KEY (id)"

      puts "Installing some groups"

      execute "INSERT into groups (id, workgroup_type_id, name) VALUES ('ppw_physician_user' ,'ppw','Physician User')"
      execute "INSERT into groups (id, workgroup_type_id, name) VALUES ('ppw_admin'          ,'ppw','Admin')"
      execute "INSERT into groups (id, workgroup_type_id, name) VALUES ('ppw_physician_proxy','ppw','Physician Proxy')"

      execute "INSERT into groups (id, workgroup_type_id, name) VALUES ('apw_admin','apw','Admin')"
      execute "INSERT into groups (id, workgroup_type_id, name) VALUES ('apw_proxy','apw','Proxy')"

    end
  end

  def self.down
    exists = Group.table_exists? rescue false
    if exists
      drop_table :groups
    end
  end
end
