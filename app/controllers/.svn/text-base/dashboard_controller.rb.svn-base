class DashboardController < ApplicationController
  before_filter :login_required
  before_filter :load_default_profile

  RESULTS_PER_PAGE = 20

  def index
    @filter = session[:dashboard_filter] || current_user.dashboard_filter || DashboardFilter.new
    @filter.workgroup_id = @workgroup.id
    @filter.user_id = current_user.id

    # default to self if self is a physician and this is a new instance of the filter
    if current_user.is_physician? and (@filter.filter_owner.nil? or @filter.filter_owner.empty?) and @filter.new_record?
      @filter.filter_owner = current_user.id
    end

    # load values from request params
    @filter.page_number = (params[:page_number] || "1").to_i
    @filter.sort_field = params[:sort] || @filter.sort_field || "type"
    @filter.sort_order = params[:order] || @filter.sort_order || "asc"

    # search by name
    @filter.search = params[:search] || @filter.search

    # filter
    @filter.filter_direction = params[:filter_direction] || @filter.filter_direction
    @filter.filter_owner = params[:filter_owner] || @filter.filter_owner
    @filter.filter_type = params[:filter_type] || @filter.filter_type
    @filter.filter_status = params[:filter_status] || @filter.filter_status

    @results, @total_pages, @total_count = Referral.search_and_filter(@filter, RESULTS_PER_PAGE)

    save_filter

    # if a request for expanding a specific referral exists, capture it
    @expand_referral = params[:expand]

    if request.xhr?
      render :partial=>"results" and return
    else
      @physicians = @workgroup.find_physicians
      @types = Tag.find(:all, :conditions=>["tag_type_id = 'referral_standard_types'"])
      status_list = ReferralTargetState.find(:all) + ReferralSourceState.find(:all)
      # we specify the array as we want a limited list of the status values to filter on
      @status_array = [["All",""],["Incomplete","new"],["New","waiting_acceptance"],["Ongoing","in_progress"],["New Info","new_info"],["Complete","closed"],["Action Requested","waiting_response"]]
    end
  end

  def quicklink
    quicklink = params[:id]

    @filter = session[:dashboard_filter] || current_user.dashboard_filter || DashboardFilter.new
    @filter.workgroup_id = @workgroup.id
    @filter.user_id = current_user.id

    # all paths:

    # have default direction set to 'all'
    @filter.filter_direction = ""

    # for the Alpha, skip this assignment for now (default to all)
    # if current_user.is_physician?
    #   # set ownership to the current user if they are a physician
    #   @filter.filter_owner = current_user.id
    # else
    #   # set ownership to all otherwise
    #   @filter.filter_owner = ""
    # end
    @filter.filter_owner = ""

    # have a specific status set
    @filter.filter_status = 'waiting_acceptance' if quicklink == 'awaiting'
    @filter.filter_status = 'new_info' if quicklink == 'new_info'
    @filter.filter_status = 'waiting_response' if quicklink == 'action_requested'
    if quicklink == 'reset'
    @filter.filter_status = ''
    @filter.filter_type  = ''
    @filter.search = ''
    end  
    @filter.filter_direction = 'in' if quicklink == 'awaiting'

    save_filter

    redirect_to dashboard_index_path
  end

  protected

  def save_filter
    session[:dashboard_filter] = @filter

    # update persistent filter values to the database per spec
    @filter.save
  end
end
