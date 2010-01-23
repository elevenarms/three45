class CreateProfileImages < ActiveRecord::Migration
  def self.up
    exists = ProfileImage.table_exists? rescue false
    if !exists
      create_table :profile_images, :id => false do |t|
        t.string :id, :limit => 36, :null => false
        t.string :profile_id, :limit => 36, :null => false

        # for attachment_fu
        t.integer :size                     # file size in bytes
        t.string  :content_type             # mime type, ex: application/mp3
        t.string  :filename                 # sanitized filename
        t.integer :height                   # in pixels
        t.integer :width                    # in pixels
        t.string  :parent_id, :limit => 36,
                  :references => nil        # id of parent image (on the same table, a self-referencing foreign-key).
                                            # Only populated if the current object is a thumbnail.
        t.string  :thumbnail                # the 'type' of thumbnail this attachment record describes.
                                            # Only populated if the current object is a thumbnail.

        t.timestamps
        t.datetime :deleted_at
      end

      puts "Setting primary key"
      execute "ALTER TABLE profile_images ADD PRIMARY KEY (id)"
    end
  end

  def self.down
    exists = ProfileImage.table_exists? rescue false
    if exists
      drop_table :profile_images
    end
  end
end
