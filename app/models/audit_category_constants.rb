#
# Constants that map each audit category into a constant for use
# within code.
#
#
#
module AuditCategoryConstants
  USER_LOGIN = 'user_login'
  USER_LOGOUT = 'user_logout'
  REFERRAL_SENT = 'referral_sent'
  REFERRAL_ACCEPTED = 'referral_accepted'
  REFERRAL_DECLINED = 'referral_declined'
  REFERRAL_CANCELLED = 'referral_cancelled'
  REFERRAL_EDITED_PATIENT = 'referral_edited_patient'
  REFERRAL_EDITED_INSURANCE = 'referral_edited_insurance'
  FILE_UPLOADED = 'file_uploaded'
  FILE_UPLOAD_FAILED = 'file_upload_failed'
  FAX_CREATED = 'fax_created'
  MESSAGE_CREATED = 'message_created'
  MESSAGE_REPLIED = 'message_replied'
  ADMIN_NEW_USER = 'admin_new_user'
  ADMIN_EDIT_WORKGROUP = 'admin_edit_workgroup'
  ADMIN_EDIT_USER = 'admin_edit_user'
  ADMIN_EDIT_TAGS_ENTERED = 'admin_edit_tags_entered'
end
