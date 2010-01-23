#
# A simple class that stores user search criteria when searching the Three45 network.
#
# Note: This class is not persistent to the database
#
#
#
class SearchCriteria

  FIELDS = [:search_mode,
            :scope_of_search,
            :provider_types,
            :specialties,
            :sub_specialties,
            :insurance_carriers,
            :insurance_carrier_plans,
            :proximity_in_miles,
            :proximity_location,
            :services,
            :diag_images,
            :diag_tests,
            :board_certified,
            :medical_school,
            :residency,
            :fellowships,
            :undergraduate,
            :hospital_privileges,
            :organization,
            :display_name]


  FIELDS.each do |x|
    attr x, true
  end

  def from_search_fields(search_fields)
    search_fields.each do |search_field|
      __send__("#{search_field[0]}=", search_field[1])
    end unless search_fields.nil?
  end
end
