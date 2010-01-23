class CreateTagSponsorViews < ActiveRecord::Migration
  def self.up
    exists = TagSponsorView.table_exists? rescue false
    if !exists
      transaction do
        create_table :tag_sponsor_views, :id => false do |t|
          t.string :id, :limit => 36, :null => false
          t.string :tag_sponsor_id, :limit => 36, :null => false, :references => nil
          t.string :user_id, :limit => 36, :null => false, :references => nil

          t.datetime :deleted_at
          t.timestamps
        end

        execute "ALTER TABLE tag_sponsor_views ADD PRIMARY KEY (id)"
      end
    end
  end

  def self.down
    exists = TagSponsorView.table_exists? rescue false
     if exists
       transaction do
         drop_table :tag_sponsor_views
       end
     end
  end
end
