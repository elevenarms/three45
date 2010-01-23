class DropReferralFaxTypes < ActiveRecord::Migration
  def self.up
    drop_table :referral_fax_types rescue false
  end

  def self.down
    # not going to undo
  end
end
