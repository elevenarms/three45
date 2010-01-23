class TagsController < ApplicationController
  before_filter :login_required
  before_filter :load_default_profile
  before_filter :load_target_tag, :except => :suggest

  RESULTS_PER_PAGE = 10

  def show
    # track a view impression of this tag
    create_tag_view!(@target_tag, current_user)

    if @target_tag.has_sponsors?
      @selected_sponsor = select_sponsor
    end

    # find a page of profiles that have the @target_tag
    @page_number = (params[:page_number] || "1").to_i
    @offset = @page_number == 1 ? nil : (@page_number-1) * RESULTS_PER_PAGE
    @friendships, @total_pages, @profile_results = execute_tag_search(@target_tag.id, RESULTS_PER_PAGE, @offset)
    @context = params[:context]
  end

  def suggest
    criteria = params['search']

    tag_type_id = criteria.keys.first unless criteria == nil || criteria.keys == nil
    tag_prefix_s = criteria[tag_type_id] unless tag_type_id == nil

    # replace 'Any' with wildcard
    tag_prefix_s = '%' if tag_prefix_s == 'Any' || tag_prefix_s == ''

    begin
      # special case sub_specialties (specialties) + insurance_plan (insurance_carrier)
      if tag_type_id == 'sub_specialties'
        tag_candidates = Tag.find(:all, :conditions => ["tag_type_id = ? && name LIKE ? && (parent_tag_id IN (SELECT id FROM tags WHERE tag_type_id = 'specialties' && name = ?))", tag_type_id, tag_prefix_s + '%', params['specialties'] ] )
      elsif tag_type_id == 'insurance_carrier_plans'
        tag_candidates = Tag.find(:all, :conditions => ["tag_type_id = ? && name LIKE ? && (parent_tag_id IN (SELECT id FROM tags WHERE tag_type_id = 'insurance_carriers' && name = ?))", tag_type_id, tag_prefix_s + '%', params['insurance_carriers'] ] )
      else
        tag_candidates = Tag.find(:all, :conditions => ["tag_type_id = ? && name LIKE ?", tag_type_id, tag_prefix_s + '%' ])
      end
    rescue => e
      logger.error("TagsController") { "Error while generating suggestions: #{e}" }
    end

    html  = "<ul>"

    tag_candidates.each do |tag_candidate|
      html += "<li>"
      html += tag_candidate.name
      html += "</li>"
    end unless tag_candidates == nil

    html += "</ul>"

    render :text => html
  end

  protected

  def create_tag_view!(tag, user)
    begin
      TagView.create!({ :tag_id=>tag.id, :user_id=>user.id})
    rescue => e
      logger.error("TagsController") { "Error during creation of tag_view: #{e}" }
    end
  end

  def select_sponsor
    if session[:last_sponsor_index].nil?
      session[:last_sponsor_index] = Hash.new
    end
    last_index_used = session[:last_sponsor_index][@target_tag.id]
    last_index_used = -1 if last_index_used.nil?
    tag_sponsors = @target_tag.find_sponsors
    next_index = last_index_used + 1
    next_index = 0 if next_index >= tag_sponsors.length
    session[:last_sponsor_index][@target_tag.id] = next_index
    selected_sponsor = tag_sponsors[next_index]
    create_tag_sponsor_view!(selected_sponsor, current_user)
    return selected_sponsor
  end

  def create_tag_sponsor_view!(tag_sponsor, user)
    begin
      TagSponsorView.create!({ :tag_sponsor_id=>tag_sponsor.id, :user_id=>user.id})
    rescue => e
      logger.error("TagsHelper") { "Error during creation of tag_sponsor_view: #{e}" }
    end
  end

end
