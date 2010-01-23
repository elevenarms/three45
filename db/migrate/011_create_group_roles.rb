class CreateGroupRoles < ActiveRecord::Migration
  def self.up
    exists = GroupRole.table_exists? rescue false
    if !exists
      create_table :group_roles, :id => false do |t|
        t.string :id, :limit => 36, :null => false
        t.string :group_id, :limit => 36, :null => false
        t.string :role_id, :limit => 36, :null => false
        t.timestamps
      end

      puts "Setting primary key"
      execute "ALTER TABLE group_roles ADD PRIMARY KEY (id)"

      puts "Installing some group_roles"

      # Based on 1/4/2008 spec, Physician Users in a PPW can do everything except manage other physicians
      execute "INSERT into group_roles (id, group_id, role_id) VALUES ('ppw_physician_user_manage_users','ppw_physician_user','manage_users')"
      execute "INSERT into group_roles (id, group_id, role_id) VALUES ('ppw_physician_user_manage_billing','ppw_physician_user','manage_billing')"
      execute "INSERT into group_roles (id, group_id, role_id) VALUES ('ppw_physician_user_manage_wg_status','ppw_physician_user','manage_workgroup_status')"
      execute "INSERT into group_roles (id, group_id, role_id) VALUES ('ppw_physician_user_manage_analytics','ppw_physician_user','manage_analytics')"
      execute "INSERT into group_roles (id, group_id, role_id) VALUES ('ppw_physician_user_network_feature','ppw_physician_user','network_feature')"
      execute "INSERT into group_roles (id, group_id, role_id) VALUES ('ppw_physician_user_network_profile','ppw_physician_user','network_profile')"
      execute "INSERT into group_roles (id, group_id, role_id) VALUES ('ppw_physician_user_network_can_add','ppw_physician_user','network_can_be_added')"

      # Based on the 1/4/2008 spec, admins cannot receive referrals or have a network profile
      execute "INSERT into group_roles (id, group_id, role_id) VALUES ('ppw_admin_manage_users','ppw_admin','manage_users')"
      execute "INSERT into group_roles (id, group_id, role_id) VALUES ('ppw_admin_manage_physician_profiles','ppw_admin','manage_physician_profiles')"
      execute "INSERT into group_roles (id, group_id, role_id) VALUES ('ppw_admin_manage_billing','ppw_admin','manage_billing')"
      execute "INSERT into group_roles (id, group_id, role_id) VALUES ('ppw_admin_manage_workgroup_status','ppw_admin','manage_workgroup_status')"
      execute "INSERT into group_roles (id, group_id, role_id) VALUES ('ppw_admin_manage_analytics','ppw_admin','manage_analytics')"

      # Based on the 1/4/2008 spec, proxies can manage other physician profiles but have no specific admin functions
      execute "INSERT into group_roles (id, group_id, role_id) VALUES ('ppw_physician_proxy_manage_phys_prof','ppw_physician_proxy','manage_physician_profiles')"

      #
      # APW
      #

      # Based on the 1/4/2008 spec, admins are owners of the APW account
      execute "INSERT into group_roles (id, group_id, role_id) VALUES ('apw_admin_manage_users','apw_admin','manage_users')"
      execute "INSERT into group_roles (id, group_id, role_id) VALUES ('apw_admin_manage_physician_profiles','apw_admin','manage_physician_profiles')"
      execute "INSERT into group_roles (id, group_id, role_id) VALUES ('apw_admin_manage_billing','apw_admin','manage_billing')"
      execute "INSERT into group_roles (id, group_id, role_id) VALUES ('apw_admin_manage_workgroup_status','apw_admin','manage_workgroup_status')"
      execute "INSERT into group_roles (id, group_id, role_id) VALUES ('apw_admin_manage_analytics','apw_admin','manage_analytics')"
      execute "INSERT into group_roles (id, group_id, role_id) VALUES ('apw_admin_network_manage_wg_prof','apw_admin','network_manage_workgroup_profile')"

      # Based on the 1/4/2008 spec, proxies can only send notes and referrals, which is out of scope for this migration
      #execute "INSERT into group_roles (id, group_id, role_id) VALUES ('','apw_proxy','')"
    end
  end

  def self.down
    exists = GroupRole.table_exists? rescue false
    if exists
      drop_table :group_roles
    end
  end
end
