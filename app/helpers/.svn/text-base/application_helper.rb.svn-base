# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include JavascriptControllerSystem
  include RailsSystem
  include SearchSystem
  include AdSystem

  def tag_list(tags, default_value="None", context=nil)
    if context.nil?
      context = @context # try to pull the instance variable
    end

    if tags.nil? or tags.empty?
      return default_value
    end

    links = Array.new
    tags.each do |tag|
      links << "<span class='tag'>#{link_to(tag.name, hash_for_network_tag_path(:id=>tag.id).merge({ :context=>context}))}</span>"
    end
    return links.join(", ")
  end

  def tag_list_with_parent(parent, tags, default_value="None")
    if tags.nil? or tags.empty? or parent.nil?
      return default_value
    end

    links = Array.new
    tags.each do |tag|
      links << "<span class='tag'>#{link_to(parent.name+":"+tag.name, network_tag_path(tag))}</span>"
    end
    return links.join(", ")
  end

  def tag_name(tag)
    return tag.name if tag.parent_tag.nil?
    return tag.parent_tag.name + ":" + tag.name
  end

  def combo_suggest_tag(id, default_value="Any", scope_id = nil, size=30)
    default_value="Any" if default_value == nil || default_value.strip == "" unless id == 'display_name'

    html  = text_field( :search, id.to_s, { :size => size, :value => default_value } )
    html += content_tag( "div", "", :id => "search_#{id.to_s}_auto_complete", :class => "auto_complete" )
    html += auto_complete_field( "search_#{id.to_s}", { :url => "/suggest" } ) if scope_id == nil
    html += auto_complete_field( "search_#{id.to_s}", { :url => "/suggest", :with => "value+'&#{scope_id}='+$('search_#{scope_id}').value" } ) unless scope_id == nil

    # observing focus/blur doesn't work in prototype [ http://dev.rubyonrails.org/ticket/9003 ], using lowpro.js instead
    unless id == 'display_name'
      html += "<script>Event.observe('search_#{id.to_s}','focus',function(e){if(this.value=='Any')this.value='';return false;});</script>"
      html += "<script>Event.observe('search_#{id.to_s}','blur',function(e){if(this.value=='')this.value='Any';return false;});</script>"
    end

    html
  end

  def show_hide_link_tag(target_id, initial_label='show')
    html  = hidden_field_tag target_id + '_show_hide_state', (initial_label=='show')?'hidden':'visible'
    html += link_to_function initial_label, nil, :id => "#{target_id}_show_hide_link", :class => "search_hide_show" do |page|
      page << "if($(&quot;#{target_id}_show_hide_link&quot;).innerHTML==&quot;show&quot;){$(&quot;#{target_id}_show_hide_link&quot;).update(&quot;hide&quot;);$(&quot;#{target_id}&quot;).show();$(&quot;#{target_id}_show_hide_state&quot;).value='visible';}else{$(&quot;#{target_id}_show_hide_link&quot;).update(&quot;show&quot;);$(&quot;#{target_id}&quot;).hide();$(&quot;#{target_id}_show_hide_state&quot;).value='hidden';}"
    end

    html
  end

  def render_block_open_ajax_links(friendship)
    return link_to_remote("Suspend Relationship", :update => "scratch",
             :url  => hash_for_block_network_friendship_url.merge({ :id=>friendship.id}), :method => :post,
             :html => { :class  => "" }) if !friendship.target_blocked?
    return link_to_remote("Restore Relationship", :update => "scratch",
             :url  => hash_for_open_network_friendship_url.merge({ :id=>friendship.id}), :method => :post,
             :html => { :class  => "" })
  end

  def render_add_to_network_ajax_link(profile)
    return link_to_remote("Add to My Network", :update => "scratch",
             :url  => hash_for_network_friendships_url.merge({ :id=>profile.id}), :method => :post,
             :html => { :class  => "" })
  end

  def display_thumbnail_or_default(profile)
    thumbnails = profile.find_thumbnails if !profile.nil?
    return image_tag( thumbnails.first.public_filename, :alt=>"" ) if !thumbnails.nil? and !thumbnails.empty?
    # default
    return image_tag( "profile-60.jpg", :alt=>"" )
  end

  def display_thumbnail_or_empty(profile)
    profile_images = profile.profile_images
    profile_images.inspect
    profile_image = profile_images.first
    profile_image.inspect
    photo = nil
    photo = profile_image.public_filename if !profile_image.nil?
    photo.inspect
    return image_tag(photo, :alt=>"" ) if !photo.nil?
    return "&nbsp;"
  end

  def display_photo_or_empty(profile)
    photo = profile.profile_images[0].public_filename
    return image_tag(photo, :alt=>"" ) if !photo.nil?
    return "&nbsp;"
  end

  def select_referring_physician( referral, select_tag_id='referring_physician', include_blank=false )
    active_source = referral.active_source
    return render_physician_select(referral, select_tag_id, include_blank, active_source)
  end

  def select_target_physician( referral, select_tag_id='referring_physician', include_blank=false )
    active_target = referral.active_target
    return render_physician_select(referral, select_tag_id, include_blank, active_target)
  end

  def render_physician_select( referral, select_tag_id, include_blank, active_source_or_target )
    created_by_user = referral.created_by_user

    if(created_by_user.is_physician?)
      option_string = ''

      option_string += '<option></option>' if include_blank

      active_source_or_target.workgroup.workgroup_users.each do |workgroup_user|
        if(workgroup_user.user.is_physician?)
          option_string += "<option value='#{workgroup_user.user.id}'>" unless !active_source_or_target.user.nil? and workgroup_user.user.id == active_source_or_target.user.id
          option_string += "<option value='#{workgroup_user.user.id}' selected='selected'>" if !active_source_or_target.user.nil? and workgroup_user.user.id == active_source_or_target.user.id
          option_string += workgroup_user.user.full_name
          option_string += '</option>'
        end
      end
    else
      # only offer blank choice if user is not physician (cannot assign no physician, once assigned)
      option_string = '<option selected="selected"></option>'

      active_source_or_target.workgroup.workgroup_users.each do |workgroup_user|
        if(workgroup_user.user.is_physician?)
          option_string += "<option value='#{workgroup_user.user.id}'>"
          option_string += workgroup_user.user.full_name
          option_string += '</option>'
        end
      end
    end

    select_tag select_tag_id, option_string
  end

  def render_tab(tab_name, default_image, down_image, path, hidden_flag=false)
    return "" if hidden_flag # allows for keeping the code but removing a tab for the alpha

    styles = ""
    active_flag = false

    if tab_name == "create_referral"
      active_flag = true if (["start_referral","create_referral"].include?(@controller.controller_name) or (!@context.nil? and @context == "referral") or params[:context] == "referral")
    elsif tab_name == "network"
      active_flag = true if (["network"].include?(@controller.controller_name) or (!@context.nil? and @context == "network"))
    elsif tab_name == "dashboard"
      active_flag = true if (["dashboard", "referrals", "messages"].include?(@controller.controller_name))
   end

    styles = "active" if active_flag
    image_path = active_flag ? down_image : default_image
    if tab_name == "help"
      return "<div class='navigation_tab #{styles}'>#{link_to image_tag(image_path), path, :target => '_blank'}</div>"
    else
    return "<div class='navigation_tab #{styles}'>#{link_to image_tag(image_path), path}</div>" if !path.nil?
    return "<div class='navigation_tab #{styles}'>#{image_tag(image_path)}</div>"
    end
  end

  def render_tab_space(width=nil)
    return "<div class=\"navigation_space\"></div>" if width.nil?
    return "<div class=\"navigation_space\" style=\"width:#{width}\"></div>"
  end

  def render_odd_class(index)
    return "odd" if index % 2 == 1
    return ""
  end

  def sort_heading_style(display_name, type)

    # set the default style class
    style_class = (@filter.sort_field == type ? "current_sort" : "")

    # set the direction of the sort if the field is the current sort column
    style_class += " asc" if @filter.sort_field == type and @filter.sort_order == "asc"
    style_class += " desc" if @filter.sort_field == type and @filter.sort_order == "desc"

    # return the link
    return style_class
  end

  def sort_referral_heading_link(display_name, type)

    # set the direction if the user clicks this column
    order = (@filter.sort_order == "desc" ? "asc" : "desc")

    # return the link
    return link_to_remote(display_name, :update=>"grid", :url=>hash_for_dashboard_index_url.merge({:sort=>type, :order=>order, :page_number=>1}), :method =>:get, :html=>{})
  end

  def sort_message_heading_link(display_name, type)

    # set the direction if the user clicks this column
    order = (@filter.sort_order == "desc" ? "asc" : "desc")

    # return the link
    return link_to_remote(display_name, :update=>"grid", :url=>hash_for_referral_messages_url({ :referral_id=>@target_referral.id}).merge({:sort=>type, :order=>order, :page_number=>1}), :method =>:get, :html=>{})
  end

  def message_status_to_style(message)
    return message.referral_message_state_id.to_s
  end

  def render_awaiting_referrals_count
    return Referral.count_awaiting_acceptance_for_workgroup(@workgroup.id)
  end

  def render_new_info_count
    return Referral.count_new_info_for_workgroup(@workgroup.id)
  end

  def render_action_requested_count
    return Referral.count_action_requested_for_workgroup(@workgroup.id)
  end

  def render_profile_referral_in_count(profile)
    return Referral.count_profile_referral_in(profile)
  end

  def render_profile_referral_out_count(profile)
    return Referral.count_profile_referral_out(profile)
  end

  #
  # Renders the link to the profile's workgroup (if this is a user profile)
  #
  def render_belongs_to(profile)
    context = @context || params[:context] || "network"
    if profile.user_profile?
      return render_workgroup_link(profile.user.workgroup_user.workgroup, context) if profile.user and profile.user.workgroup_user and profile.user.workgroup_user.workgroup
    else
      return render_physician_links(profile.workgroup, context) if profile.workgroup
    end

    return ""
  end

  #
  # Generates a link to a workgroup's default profile, if available. Otherwise, returns an empty string
  #
  def render_workgroup_link(workgroup, context)
    return link_to(workgroup.name, { :context=>context}.merge(hash_for_network_profile_path(:id=>workgroup.profiles.first.id))) if workgroup.profiles.first
    return ""
  end

  #
  # Generates a link to a workgroup's physician profiles, one per line. Otherwise, returns an empty string
  #
  def render_physician_links(workgroup, context)
    result = ""
    physicians = workgroup.find_physicians
    physicians.each do |phys|
      result += link_to(phys.full_name, { :context=>context}.merge(hash_for_network_profile_path(:id=>phys.load_default_profile(workgroup).id))) + "<br/>"
    end
    return result
  end
end
