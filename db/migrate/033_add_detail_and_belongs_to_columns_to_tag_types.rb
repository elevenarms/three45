class AddDetailAndBelongsToColumnsToTagTypes < ActiveRecord::Migration
  def self.up
    add_column :tag_types, :show_details_flag, :boolean
    add_column :tag_types, :parent_tag_type_id, :string, :limit=>36, :references=>:tag_types
  end

  def self.down
    remove_column :tag_types, :show_details_flag
    remove_column :tag_types, :parent_tag_type_id
  end
end
