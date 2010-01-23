#
# Referral files may be documents, images, and other files uploaded into the system by
# the referral source or target. No thumbnails or other manipulation is currently done
# by the system. A third-party document server may be used in the future to create thumbnails for
# previewing document contents.
#
#
#
class ReferralFile < ActiveRecord::Base
  uses_guid
  acts_as_paranoid

  # NOTE: be sure to set nginx's upload limit value to whatever the limit is for
  #       this model - prob 10MB or more
  has_attachment  :storage => :file_system,
                  :path_prefix => 'public/files',
                  :max_size => 10.megabytes

  belongs_to :referral
  belongs_to :referral_file_type
  belongs_to :mime_type
end
