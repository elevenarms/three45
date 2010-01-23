#
# Tracks the patient details for a Referral
#
#
#
class ReferralPatient < ActiveRecord::Base
  uses_guid
  acts_as_paranoid
  belongs_to :referral

  def full_name
    full_name = ''

    full_name += first_name + ' ' unless first_name == nil
    full_name += middle_name + ' ' unless middle_name == nil
    full_name += last_name unless last_name == nil

    full_name
  end

  def last_first
    full_name = ''

    full_name += last_name unless last_name == nil
    full_name += ', '+first_name + ' ' unless first_name == nil
    full_name += middle_name + ' ' unless middle_name == nil

    full_name
  end

  def male?
    return (gender == 'm' or gender == "M")
  end

  def female?
    return (gender == 'f' or gender == "F")
  end

  def display_ssn
    # TODO: format to xxx-xx-xxxx if it isn't already formatted that way
    return ssn.to_s
  end

  def display_dob
    return dob.strftime("%m-%d-%Y") if dob
    return ""
  end

  def display_dob_search_format
    return dob.strftime("%Y-%m-%d")
  end

  def display_gender
    return "Male" if male?
    return "Female" if female?
    return ""
  end

  def display_phone
    return "#{self.phone}" if !self.phone.nil? and !self.phone.empty?
    return "N/A"
  end

  def self.find_eager(id)
    return ReferralPatient.find(:first, :conditions=>["referral_patients.id = ?", id], :include=>[:referral])
  end
end
