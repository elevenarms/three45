class CreateTags < ActiveRecord::Migration
  def self.up
    exists = Tag.table_exists? rescue false
    if !exists
      transaction do
        create_table :tags, :id => false do |t|
          t.string :id, :limit => 36, :null => false
          t.string :tag_type_id, :limit => 36, :null => false, :references => nil
          t.string :name, :null => false

          t.datetime :deleted_at
          t.timestamps
        end

        execute "ALTER TABLE tags ADD PRIMARY KEY (id)"
      end
    end
  end

  def self.down
    exists = Tag.table_exists? rescue false
     if exists
       transaction do
         drop_table :tags
       end
     end
  end
end
