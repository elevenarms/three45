class CreateRegistrations < ActiveRecord::Migration
  def self.up
    exists = Registration.table_exists? rescue false
    if !exists
      create_table :registrations, :id => false do |t|
        t.string :id, :limit => 36, :null => false
        t.string :subdomain
        t.string :workgroup_name
        t.string :workgroup_id
        t.string :last_name
        t.string :first_name
        t.string :login
        t.string :user_id
        t.string :email
        t.string :password
        t.boolean :physician_reg, :default => false  #person doing the registration is also a physician
        t.string :card_type
        t.string :card_number
        t.string :billing_zip_code
        t.string :expiration_month
        t.string :expiration_year
        t.integer :num_physicians
        t.string :physician_first_name
        t.string :physician_middle_name
        t.string :physician_last_name
        t.string :physician_npi
        t.string :physician_med_license
        t.string :physician_uid
        t.string :office_phone
        t.string :office_fax
        t.string :plan
        t.string :fee
        t.text   :comments
        t.string :status_code
        t.datetime :deleted_at
        t.timestamps
      end
      #puts "Setting primary key"
      #execute "ALTER TABLE registrations ADD PRIMARY KEY (id)"  
      #puts "Setting up foreign key relationship for physician_uid as a user"
      #execute "ALTER TABLE registrations ADD CONSTRAINT `FK_registrations_3` FOREIGN KEY `FK_registrations_3` (`physician_uid`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT; "     
    end
  end
  

  def self.down
    exists = Registration.table_exists? rescue false
    if exists
      drop_table :registrations
    end

  end
end
