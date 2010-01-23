class CreateTagViews < ActiveRecord::Migration
  def self.up
    exists = TagView.table_exists? rescue false
    if !exists
      transaction do
        create_table :tag_views, :id => false do |t|
          t.string :id, :limit => 36, :null => false
          t.string :tag_id, :limit => 36, :null => false, :references => nil          
          t.string :user_id, :limit => 36, :null => false, :references => nil          

          t.datetime :deleted_at
          t.timestamps
        end

        execute "ALTER TABLE tag_views ADD PRIMARY KEY (id)"
      end
    end
  end

  def self.down
    exists = TagView.table_exists? rescue false
     if exists
       transaction do
         drop_table :tag_views
       end
     end
  end
end
