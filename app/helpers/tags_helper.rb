module TagsHelper

  def render_tag_details
    if @target_tag.tag_type.show_details_flag?
      render :partial=>"tag_details"
    end
  end

  def render_tag_sponsor
    if @selected_sponsor
      render :partial=>"tag_sponsor", :locals => { :tag_sponsor => @selected_sponsor }
    end
  end

end
