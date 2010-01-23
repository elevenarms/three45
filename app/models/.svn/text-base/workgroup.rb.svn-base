#
# A Workgroup represents a billable group, typically a practice or office. Workgroups have an associated
# subdomain that is used to define their portal (myoffice.three45.net).
#
#
#
class Workgroup < ActiveRecord::Base
  uses_guid
  acts_as_paranoid

  belongs_to :workgroup_type
  validates_presence_of :workgroup_type

  belongs_to :workgroup_subtype
  validates_presence_of :workgroup_subtype

  belongs_to :workgroup_state
  validates_presence_of :workgroup_state

  has_many :workgroup_users
  has_many :workgroup_addresses
  has_many :profiles
  has_one :registration
  
  validates_presence_of :subdomain
  validates_uniqueness_of :subdomain

  def self.find_eager_paranoid(id)
    return  Workgroup.find(id, :include => {:workgroup_addresses => [:address, :address_type]}, :conditions => "workgroup_addresses.deleted_at IS NULL AND addresses.deleted_at IS NULL AND address_types.deleted_at IS NULL")
  end

  def is_member?(user)
    workgroup_users.each do |wu|
      return true if wu.user_id == user.id
    end
    return false
  end

  def allowed_to_sign_and_send?(user)
    return false if !is_member?(user)
    return true if self.anyone_can_sign_referral_flag == true or self.workgroup_type_id == 'apw'
    return true if user.is_physician?
    return false
  end

  def ppw?
    return self.workgroup_type_id == "ppw"
  end

  def apw?
    return self.workgroup_type_id == "apw"
  end

  # return true if the organization is a subscriber. Return false otherwise (org is a "UNS" - User Non Subscriber)
  def subscriber?
    return subscriber_flag == true
  end

  def find_physicians
    return User.find(:all, :conditions=>["(user_groups.group_id = 'ppw_physician_user' AND workgroup_users.workgroup_id = ?)",self.id], :include=>[:user_groups, :workgroup_user])
  end

  # returns the first profile associated to this workgroup, or nil if not found
  def find_default_profile
    return profiles.first
  end
end
