#
# A ReferralFax can have 1 or more ReferralFaxFiles associated with it. We think the
# fax service will send us a single file (multi-page PDF or TIFF), but just in case, we
# support more than one file (1 file per page, if required)
#
class ReferralFaxFile < ActiveRecord::Base
  uses_guid
  acts_as_paranoid

  belongs_to :referral
  belongs_to :referral_fax

  # NOTE: be sure to set nginx's upload limit value to whatever the limit is for
  #       this model - prob 10MB or more
  has_attachment  :storage => :file_system,
                  :path_prefix => 'public/faxes',
                  :max_size => 10.megabytes
end
