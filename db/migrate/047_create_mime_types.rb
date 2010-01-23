class CreateMimeTypes < ActiveRecord::Migration
  def self.up
    exists = MimeType.table_exists? rescue false
    if !exists
      create_table :mime_types, :id => false do |t|
        t.string :id, :limit => 36, :null => false
        t.string :name, :null => false
        t.timestamps
        t.datetime :deleted_at
      end

      puts "Setting primary key"
      execute "ALTER TABLE mime_types ADD PRIMARY KEY (id)"
    end
  end

  def self.down
    exists = MimeType.table_exists? rescue false
    if exists
      drop_table :mime_types
    end
  end
end
