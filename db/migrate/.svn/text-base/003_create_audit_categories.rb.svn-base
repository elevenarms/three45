class CreateAuditCategories < ActiveRecord::Migration
  def self.up
    exists = AuditCategory.table_exists? rescue false
    if !exists
      create_table :audit_categories, :id => false do |t|
        t.string :id, :limit => 36, :null => false
        t.string :name, :null => false
        t.timestamps
      end

      puts "Setting primary key"
      execute "ALTER TABLE audit_categories ADD PRIMARY KEY (id)"

      puts "Installing some categories"
      execute "INSERT into audit_categories (id, name) VALUES ('acct_login','Account Login')"
      execute "INSERT into audit_categories (id, name) VALUES ('acct_logout','Account Logout')"
      execute "INSERT into audit_categories (id, name) VALUES ('acct_created','Account Created')"
    end
  end

  def self.down
    exists = AuditCategory.table_exists? rescue false
    if exists
      drop_table :audit_categories
    end
  end
end
