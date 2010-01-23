class AddLongerDetailColumnToTags < ActiveRecord::Migration
  def self.up
    remove_column :tags, :detail_text
    add_column :tags, :detail_text, :text
  end

  def self.down
    remove_column :tags, :detail_text
    add_column :tags, :detail_text, :string
  end
end
