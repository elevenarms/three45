class CreateTagSponsors < ActiveRecord::Migration
  def self.up
    exists = TagSponsor.table_exists? rescue false
    if !exists
      transaction do
        create_table :tag_sponsors, :id => false do |t|
          t.string :id, :limit => 36, :null => false
          t.string :tag_id, :limit => 36, :null => false, :references => nil

          t.string :name
          t.string :image_path
          t.string :link_url
          
          t.datetime :deleted_at
          t.timestamps
        end

        execute "ALTER TABLE tag_sponsors ADD PRIMARY KEY (id)"
      end
    end
  end

  def self.down
    exists = TagSponsor.table_exists? rescue false
     if exists
       transaction do
         drop_table :tag_sponsors
       end
     end
  end
end
