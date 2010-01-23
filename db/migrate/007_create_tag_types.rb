class CreateTagTypes < ActiveRecord::Migration
  def self.up
    exists = TagType.table_exists? rescue false
    if !exists
      transaction do
        create_table :tag_types, :id => false do |t|
          t.string :id, :limit => 36, :null => false
          t.string :name, :null => false

          t.datetime :deleted_at
          t.timestamps
        end

        execute "ALTER TABLE tag_types ADD PRIMARY KEY (id)"
      end
    end
  end

  def self.down
    exists = TagType.table_exists? rescue false
     if exists
       transaction do
         drop_table :tag_types
       end
     end
  end
end
