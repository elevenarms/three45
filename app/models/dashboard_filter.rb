#
# Stores user-specific dashboard filters across sessions. Any attributes declared within this model
# are used by the UI but not stored after the session has expired.
#
#
#
class DashboardFilter < ActiveRecord::Base
  uses_guid
  belongs_to :user

  attr :search, true
  attr :page_number, true
  attr :workgroup_id, true
  attr :sort_field, true
  attr :sort_order, true
  attr :filter_status, true

  def filter_by_direction?
    return (!filter_direction.nil? and !filter_direction.empty?)
  end

  def filter_by_owner?
    return (!filter_owner.nil? and !filter_owner.empty?)
  end

  def filter_by_type?
    return (!filter_type.nil? and !filter_type.empty?)
  end

  def filter_by_status?
    return (!filter_status.nil? and !filter_status.empty?)
  end

  def to_order_by
    # convert the sort_field 'short value' into the proper order by clause

    if sort_field == 'type'
      return "referral_type_name #{sort_order}"
    end

    if sort_field == 'status'
      return "status #{sort_order}"
    end

    if sort_field == 'patient'
      return "patient_last_name #{sort_order}, patient_first_name"
    end

    if sort_field == 'dob'
      return "patient_dob #{sort_order}"
    end

    if sort_field == 'ssn'
      return "patient_ssn #{sort_order}"
    end

    if sort_field == 'to'
      return "to_name #{sort_order}"
    end

    if sort_field == 'from'
      return "from_name #{sort_order}"
    end

    return nil
  end
end
