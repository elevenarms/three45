class CreateAds < ActiveRecord::Migration
  def self.up
    exists = Ad.table_exists? rescue false
    if !exists
      create_table :ads, :id => false do |t|
        t.string :id, :limit => 36, :null => false
        t.string :workgroup_id, :limit => 36 # the workgroup this ad is targeted for (during ALPHA)
        t.string :image_path
        t.string :link_url

        t.datetime :deleted_at
        t.timestamps
      end

      execute "ALTER TABLE ads ADD PRIMARY KEY (id)"
    end
  end

  def self.down
    exists = Ad.table_exists? rescue false
    if exists
      drop_table :ads
    end
  end
end
