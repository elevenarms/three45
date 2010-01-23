class AddReferralRequestMessageType < ActiveRecord::Migration
  def self.up
    execute "INSERT into referral_message_types (id, name) values ('referral_request','Referral Request')" if ReferralMessageType.find_by_id('referral_request').nil?
  end

  def self.down
    # no need to remove it
  end
end
