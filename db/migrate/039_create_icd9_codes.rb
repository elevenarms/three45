class CreateIcd9Codes < ActiveRecord::Migration
  def self.up
    exists = Icd9Code.table_exists? rescue false
    if !exists
      create_table :icd9_codes, :id => false do |t|
        t.string :id, :limit => 36, :null => false
        t.string :name, :null => false
        t.timestamps
        t.datetime :deleted_at
      end

      puts "Setting primary key"
      execute "ALTER TABLE icd9_codes ADD PRIMARY KEY (id)"
    end
  end

  def self.down
    exists = Icd9Code.table_exists? rescue false
    if exists
      drop_table :icd9_codes
    end
  end
end
