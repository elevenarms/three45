class CreateTagLogos < ActiveRecord::Migration
  def self.up
    exists = TagLogo.table_exists? rescue false
    if !exists
      transaction do
        create_table :tag_logos, :id => false do |t|
          t.string :id, :limit => 36, :null => false
          t.string :tag_id, :limit => 36, :null => false, :references => nil

          t.string :path
          t.integer :height
          t.integer :width

          t.datetime :deleted_at
          t.timestamps
        end

        execute "ALTER TABLE tag_logos ADD PRIMARY KEY (id)"
      end
    end
  end

  def self.down
    exists = TagLogo.table_exists? rescue false
     if exists
       transaction do
         drop_table :tag_logos
       end
     end
  end
end
