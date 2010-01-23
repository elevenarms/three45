class CreateRoles < ActiveRecord::Migration
  def self.up
    exists = Role.table_exists? rescue false
    if !exists
      create_table :roles, :id => false do |t|
        t.string :id, :limit => 36, :null => false
        t.string :name, :null => false
        t.timestamps
      end

      puts "Setting primary key"
      execute "ALTER TABLE roles ADD PRIMARY KEY (id)"

      puts "Installing some roles"

      execute "INSERT into roles (id, name) VALUES ('manage_users','Can add and remove users for the workgroup')"
      execute "INSERT into roles (id, name) VALUES ('manage_physician_profiles','Can edit physician profiles of the workgroup')"
      execute "INSERT into roles (id, name) VALUES ('manage_billing','Can manage billing details for the workgroup')"
      execute "INSERT into roles (id, name) VALUES ('manage_workgroup_status','Can deactivate/reactivate the workgroup account')"
      execute "INSERT into roles (id, name) VALUES ('manage_analytics','Can access the analytics data for the workgroup')"

      execute "INSERT into roles (id, name) VALUES ('network_feature','Can have the network feature')"
      execute "INSERT into roles (id, name) VALUES ('network_profile','Can have a network profile')"
      execute "INSERT into roles (id, name) VALUES ('network_can_be_added','Can be added as a friend/colleague by another profile')"
      execute "INSERT into roles (id, name) VALUES ('network_manage_workgroup_profile','Can manage the network profile for a workgroup')"

    end
  end

  def self.down
    exists = Role.table_exists? rescue false
    if exists
      drop_table :roles
    end
  end
end
