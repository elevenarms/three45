#
# Associates a User to a Workgroup for membership. If no entry for the user + workgroup exists, they are not
# considered a member and should be denied access to the workgroup portal.
#
#
#
class WorkgroupUser < ActiveRecord::Base
  uses_guid
  acts_as_paranoid

  belongs_to :user
  validates_presence_of :user

  belongs_to :workgroup
  validates_presence_of :workgroup

  def self.default_workgroup_for_user(user)
    workgroup_user = WorkgroupUser.find(:first, :conditions=>["user_id = ?", user.id], :include=>:workgroup)

    # according to the spec, any user-based profile must be a physician and thus a member
    # of only one workgroup at a time. So, we'll take the first workgroup from the user
    return workgroup_user.workgroup if !workgroup_user.nil?

    # couldn't find it
    return nil
  end
end
