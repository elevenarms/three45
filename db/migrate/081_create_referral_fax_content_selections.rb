class CreateReferralFaxContentSelections < ActiveRecord::Migration
  def self.up
    create_table :referral_fax_content_selections do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :referral_fax_content_selections
  end
end
