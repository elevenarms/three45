module FaxesHelper
  include SelectPhysicianHelper

  def fax_content_list(content_selections)
    html = ""

    content_selections.each_with_index do |content_selection, ndx|
      html += ', ' + Tag.find( content_selection.tag_id ).name unless ndx == 0
      html += Tag.find( content_selection.tag_id ).name if ndx == 0
    end

    return html unless html.empty?
    return "N/A"
  end

  def fax_content_buttons(content_selections = [])
    html = "<table><tr>"

    Tag.find( :all, :conditions => [ "tag_type_id = ?", 'referral_fax_content_types' ] ).each_with_index do |content_type, ndx|
      html += "<td style='padding:0px;'><input type='checkbox' name='#{content_type.id}'"
      html += " checked='checked'" if content_type_is_selected( content_type, content_selections )
      html += " value='#{content_type.id}'>&nbsp;#{content_type.name}&nbsp;</input></td>"
      html += "</tr><tr>" if ndx % 4 == 3
    end

    html += "</tr></table>"
    html
  end

  def content_type_is_selected( content_type, content_selections )
    content_selections.each do |content_selection|
      return true if content_selection.tag_id == content_type.id
    end

    false
  end
end
