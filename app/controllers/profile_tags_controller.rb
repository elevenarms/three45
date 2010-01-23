class ProfileTagsController < ApplicationController
  before_filter :login_required
  before_filter :load_target_profile_friendly, :only=>[:show, :new]
  before_filter :load_target_profile_tag, :only=>[:destroy]

  def index
    @profiles = Profile.find_all_profiles_for_workgroup(@workgroup) if @workgroup
    @profiles = Array.new unless @workgroup

    # audit log
    log_admin_edit_tags_entered(current_user, @workgroup)
  end

  def show
    @profile_tags = @target_profile.profile_tags.find(:all, :include=>[:tag, :tag_type])
    @profile_tags.sort! {|x,y| x.tag.display_name <=> y.tag.display_name }
    # XHR-only for now
    render :update do |page|
      page.replace_html 'profile_tag_detail_partial', :partial=>"show"
    end
  end

  # this action is called when the user clicks the 'add' link and re-entered each time a user selects something from
  # the tag type/tag/child tag choice box is selected
  def new
    exclusion_id_list = [] # add a list of ids to exclude specific types from the list
    @profile_tag =  (params[:profile_tag].nil?) ? ProfileTag.new : ProfileTag.new(params[:profile_tag])
    @profile_tag.profile_id = @target_profile.id

    # load the tag types
    @tag_types = TagType.find_all_with_exclusions(exclusion_id_list)
    # load the tags for the tag type, if selected
    @tags_for_types = Tag.find_tags_for_type(@profile_tag.tag_type_id) if @profile_tag.tag_type_id and !@profile_tag.tag_type_id.empty?
    # try to load any child tags for the selected tag, in case it is a parent (empty array if no children)
    @child_tags = Tag.find_child_tags_for_tag(@profile_tag.tag_id) if @profile_tag.tag_id and !params[:parent_tag_id]
    @child_tags = Tag.find_child_tags_for_tag(params[:parent_tag_id]) if params[:parent_tag_id]

    # load the profiles for the checkbox rendering support
    @profiles = Profile.find_all_profiles_for_workgroup(@workgroup) if @workgroup
    @profiles = Array.new unless @workgroup

    # XHR-only for now
    render :update do |page|
      page.replace_html 'add_profile_tag_partial', :partial=>"new"
      page.hide 'add_profile_link'
      page.show 'add_profile_tag_partial'
      page.show 'submit_button' if (@profile_tag.tag_id and @child_tags.empty?) or (@profile_tag.tag_id and params[:parent_tag_id] and !@child_tags.empty?)
      page.hide 'submit_button' unless (@profile_tag.tag_id and @child_tags.empty?) or (@profile_tag.tag_id and params[:parent_tag_id] and !@child_tags.empty?)
    end
  end

  def create
    # the primary target profile we want to attach the tag(s) to
    @target_profile = Profile.find_by_id(params[:profile_tag][:profile_id])

    # if a parent tag id was provided, then load it for later use
    if params[:parent_tag_id]
      @parent_tag = Tag.find(params[:parent_tag_id])
    end

    profile_tag = ProfileTag.new(params[:profile_tag])

    # load the tag selected (basic tag or child of a parent tag) and set the correct tag_type_id
    target_tag = Tag.find(profile_tag.tag_id)
    profile_tag.tag_type_id = target_tag.tag_type_id

    # tag the profile we are working on
    @profile_tag, @profile_tag_parent = create_profile_tag_for(@target_profile, profile_tag, @parent_tag)

    @additional_profile_tags = Array.new
    @additional_profile_tag_parents = Array.new

    # tag any additional profiles we were given
    if params[:additional_profile_ids]
      params[:additional_profile_ids].each do |additional_profile_id|
        additional_profile = Profile.find_by_id(additional_profile_id)
        if additional_profile
          additional_profile_tag = ProfileTag.new(params[:profile_tag])
          additional_profile_tag.tag_type_id = target_tag.tag_type_id
          additional_profile_tag, additional_profile_tag_parent = create_profile_tag_for(additional_profile, additional_profile_tag, @parent_tag)
          @additional_profile_tags << additional_profile_tag
          @additional_profile_tag_parents << additional_profile_tag_parent
        end
      end
    end

    # response is XHR-only for now
    @profile_tags = @target_profile.profile_tags.find(:all, :include=>[:tag, :tag_type])
    @profile_tags.sort! {|x,y| x.tag.display_name <=> y.tag.display_name }
    render :update do |page|
      page.replace_html 'profile_tag_detail_partial', :partial=>"show"
      page.show 'add_profile_link'
      page.hide 'add_profile_tag_partial'
      page.visual_effect :highlight, dom_id(@profile_tag)
      page.visual_effect :highlight, dom_id(@profile_tag_parent) if !@profile_tag_parent.nil?
    end
  end

  def destroy
    @target_profile_tag.destroy

    # XHR-only for now
    render :update do |page|
      page.visual_effect :fade, dom_id(@target_profile_tag)
    end
  end

  protected

  def create_profile_tag_for(target_profile, profile_tag, parent_tag=nil)
    # set the profile id for the profile_tag based on the target profile given, to be sure the FK is set properly
    # (overriding any form specifics for the primary profile with any secondary profiles)
    profile_tag.profile_id = target_profile.id

    # if there was a parent tag selected, we want to make sure that the profile has the parent tag attached
    # (this allows the adv search to filter on insurance carriers along with plans, e.g. 'blue cross' + 'gold plan')
    if parent_tag
      profile_tag_parent = target_profile.profile_tag_by_id(params[:parent_tag_id]) || ProfileTag.new({ :profile_id=>profile_tag.profile_id, :tag_id=>parent_tag.id, :tag_type_id=>parent_tag.tag_type_id})
    end

    # if there was a parent tag selected, we want to make sure that the profile has the parent tag attached
    # (this allows the adv search to filter on insurance carriers along with plans, e.g. 'blue cross' + 'gold plan')
    if profile_tag.save
      profile_tag_parent.save if !profile_tag_parent.nil? and profile_tag_parent.new_record?
      return profile_tag, profile_tag_parent
    end

    return nil
  end

end
