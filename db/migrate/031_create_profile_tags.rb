class CreateProfileTags < ActiveRecord::Migration
  def self.up
    exists = ProfileTag.table_exists? rescue false
    if !exists
      create_table :profile_tags, :id => false do |t|
        t.string :id, :limit => 36, :null => false
        t.string :profile_id, :limit => 36, :null => false
        t.string :tag_type_id, :limit => 36, :null => false
        t.string :tag_id, :limit => 36, :null => false
        t.timestamps
        t.datetime :deleted_at
      end

      puts "Setting primary key"
      execute "ALTER TABLE profile_tags ADD PRIMARY KEY (id)"
    end
  end

  def self.down
    exists = ProfileTag.table_exists? rescue false
    if exists
      drop_table :profile_tags
    end
  end
end
