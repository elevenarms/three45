class RecreateReferralFaxContentSelections < ActiveRecord::Migration
  def self.up
    drop_table :referral_fax_content_selections
    
    # need to recreate with correct index type
    create_table :referral_fax_content_selections, :id => false do |t|
      t.string  :id, :limit => 36, :null => false
      t.string  :referral_fax_id, :limit => 36, :null => false
      t.string  :tag_id, :limit => 36, :null => false
      t.string  :other_text

      t.timestamps
      t.datetime :deleted_at
    end

    puts "Setting primary key"
    execute "ALTER TABLE referral_fax_content_selections ADD PRIMARY KEY (id)"
  end

  def self.down
    # roll forward only
  end
end
