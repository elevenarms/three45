class CreateAdViews < ActiveRecord::Migration
  def self.up
    exists = AdView.table_exists? rescue false
    if !exists
      create_table :ad_views, :id => false do |t|
        t.string :id, :limit => 36, :null => false
        t.string :ad_id, :limit => 36, :null => false
        t.string :user_id

        t.datetime :deleted_at
        t.timestamps
      end

      execute "ALTER TABLE ad_views ADD PRIMARY KEY (id)"
    end
  end

  def self.down
    exists = AdView.table_exists? rescue false
    if exists
      drop_table :ad_views
    end
  end
end
