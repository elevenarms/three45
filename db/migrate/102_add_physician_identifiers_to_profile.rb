class AddPhysicianIdentifiersToProfile < ActiveRecord::Migration
  def self.up
    add_column :profiles, :npi_identifier, :string, :limit=>20
    add_column :profiles, :medical_license_id, :string, :limit=>20, :references=>nil
  end

  def self.down
    remove_column :profiles, :npi_identifier
    remove_column :profiles, :medical_license_id
  end
end
