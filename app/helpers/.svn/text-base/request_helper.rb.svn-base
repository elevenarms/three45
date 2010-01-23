module RequestHelper
  def request_type_options(selected_referral_type_id = 'tag_consultation_type')
    html = ""
    
    Tag.find_all_by_tag_type_id( 'referral_standard_types' ).each do |referral_standard_type|
      if selected_referral_type_id && referral_standard_type.id == selected_referral_type_id
        html += "<option value = '#{referral_standard_type.id}' selected = 'selected'>" + referral_standard_type.name + "</option>"
      else
        html += "<option value = '#{referral_standard_type.id}'>" + referral_standard_type.name + "</option>"
      end
    end

    html
  end
end
