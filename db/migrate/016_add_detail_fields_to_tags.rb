class AddDetailFieldsToTags < ActiveRecord::Migration
  def self.up
    add_column :tags, :detail_text, :string
    add_column :tags, :contact_details, :string
  end

  def self.down
    remove_column :tags, :detail_text
    remove_column :tags, :contact_details
  end
end
