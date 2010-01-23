#
# Stores a new registration signup for processing by a Three45 Admin.
#
#
#
class Registration < ActiveRecord::Base
  uses_guid
  acts_as_paranoid

  belongs_to :user
  belongs_to :workgroup
end
