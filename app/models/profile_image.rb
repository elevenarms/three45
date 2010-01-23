#
# Provides a profile thumbnail image. The attached image is converted to a smaller thumbnail using
# the ImageScience image processing engine.
#
#
#
class ProfileImage < ActiveRecord::Base
  uses_guid
  acts_as_paranoid
  # when the time comes, should setup thumbnail for 60x60 unless the UI changes to allow a different size
  has_attachment :storage => :file_system, :path_prefix => 'public/profile_images',
                 :content_type => :image, :resize_to => '80x96',
                 :processor => 'ImageScience'

  belongs_to :profile
end
