class CreateAdClicks < ActiveRecord::Migration
  def self.up
    exists = AdClick.table_exists? rescue false
    if !exists
      create_table :ad_clicks, :id => false do |t|
        t.string :id, :limit => 36, :null => false
        t.string :ad_id, :limit => 36, :null => false
        t.string :user_id

        t.datetime :deleted_at
        t.timestamps
      end

      execute "ALTER TABLE ad_clicks ADD PRIMARY KEY (id)"
    end
  end

  def self.down
    exists = AdClick.table_exists? rescue false
    if exists
      drop_table :ad_clicks
    end
  end
end
