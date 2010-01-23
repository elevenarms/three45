class CreateCptCodes < ActiveRecord::Migration
  def self.up
    exists = CptCode.table_exists? rescue false
    if !exists
      create_table :cpt_codes, :id => false do |t|
        t.string :id, :limit => 36, :null => false
        t.string :name, :null => false
        t.timestamps
        t.datetime :deleted_at
      end

      puts "Setting primary key"
      execute "ALTER TABLE cpt_codes ADD PRIMARY KEY (id)"
    end
  end

  def self.down
    exists = CptCode.table_exists? rescue false
    if exists
      drop_table :cpt_codes
    end
  end
end
