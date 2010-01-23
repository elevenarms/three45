class AddParentToTags < ActiveRecord::Migration
  def self.up
    add_column :tags, :parent_tag_id, :string, :limit=>36, :references=>:tags
  end

  def self.down
    remove_column :tags, :parent_tag_id
  end
end
