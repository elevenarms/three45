#
# Represents a single action within the system, taken by the user or on behalf
# of a user. An AuditLog has an associated AuditCategory and additional details, as appropriate.
#
#
#
#
class AuditLog < ActiveRecord::Base
  uses_guid
  belongs_to :audit_category
  validates_presence_of :audit_category
end
