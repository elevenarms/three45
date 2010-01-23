#
# Lookup table/model that defines the mime type of a file.
#
#
#
class MimeType < ActiveRecord::Base
  uses_guid
  acts_as_paranoid
end
