#
# Associates a user to an ACL Group. If the user is associated to the 'ppw_physician_user'
# Group id, the user is considered a physician.
#
#
#
class UserGroup < ActiveRecord::Base
  uses_guid
  belongs_to :user
  belongs_to :group

  def physician?
    return true if self.group_id == 'ppw_physician_user'
    return false
  end
end
