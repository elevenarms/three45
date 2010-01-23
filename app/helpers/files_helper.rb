module FilesHelper
  include FaxesHelper

  def file_type_radio_buttons(selected_file_type = nil)
    html = ""
    
    ReferralFileType.find(:all).each do |file_type|
      html += "<input type='radio' name='file_type_id' value='#{file_type.id}'> #{file_type.name}&nbsp;&nbsp;</input>" unless file_type == selected_file_type
      html += "<input type='radio' name='file_type_id' value='#{file_type.id}' checked> #{file_type.name}&nbsp;&nbsp;</input>" if file_type == selected_file_type
    end

    html
  end
end
