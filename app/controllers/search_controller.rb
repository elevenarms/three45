class SearchController < ApplicationController
  before_filter :login_required
  before_filter :load_default_profile

  RESULTS_PER_PAGE = 10

  #
  # Starts a new network search, with or without referral support based on the parent controller
  # referenced in the URL
  #
  def create
    # package up search params
    @search_criteria = SearchCriteria.new
    @search_criteria.from_search_fields( params['search'] )

    # track scope of search
    @search_criteria.scope_of_search = params['network']

    # default scope to entire_network
    @search_criteria.scope_of_search = 'entire_network' if @search_criteria.scope_of_search == nil

    # preserve search mode
    @search_criteria.search_mode = params['search_mode'] if @search_criteria.search_mode == nil

    # default mode to basic
    @search_criteria.search_mode = 'basic' if @search_criteria.search_mode == nil

    # track certification
    @search_criteria.board_certified = params['board_certified'] unless params['board_certified'] == nil

    @page_number = (params[:page_number] || "1").to_i
    @offset = @page_number == 1 ? nil : (@page_number-1) * RESULTS_PER_PAGE
    @profile_results, @total_pages, @friendships = execute_network_search(RESULTS_PER_PAGE, @offset, @search_criteria)

    @context = (params[:context] || "network")

    if( request.request_uri.include?( 'start_referral' ) && @context == "referral")
      @context = "referral"
      render :template=>'start_referral/show'
    elsif( request.request_uri.include?( 'request_referral' ) || @context =="request_referral" )
      @context = "request_referral"
      render :template=>'request_referral/show'
    else
      render :template=>'network/show'
    end
  end

  def show
    # package up search params
    @search_criteria = SearchCriteria.new
    @search_criteria.from_search_fields( params['search'] )

    # track scope of search
    @search_criteria.scope_of_search = params['network']

    # default scope to entire_network
    @search_criteria.scope_of_search = 'entire_network' if @search_criteria.scope_of_search == nil

    # preserve search mode
    @search_criteria.search_mode = params['search_mode'] if @search_criteria.search_mode == nil

    # default mode to basic
    @search_criteria.search_mode = 'basic' if @search_criteria.search_mode == nil

    # track certification
    @search_criteria.board_certified = params['board_certified'] unless params['board_certified'] == nil

    @page_number = (params[:page_number] || "1").to_i
    @offset = @page_number == 1 ? nil : (@page_number-1) * RESULTS_PER_PAGE
    @profile_results, @total_pages, @friendships = execute_network_search(RESULTS_PER_PAGE, @offset, @search_criteria)

    if( request.request_uri.include?( 'start_referral' ) )
      @context = "referral"
      render :template=>'start_referral/show'
    elsif( request.request_uri.include?( 'request_referral' ) )
      @context = "request_referral"
      render :template=>'request_referral/show'
    else
      render :template=>'network/show'
    end
  end

  def toggle_basic_mode
    # package up search params
    @search_criteria = SearchCriteria.new
    @search_criteria.from_search_fields( params['search'] )

    # track scope of search
    @search_criteria.scope_of_search = params['network']

    # default scope to entire_network
    @search_criteria.scope_of_search = 'entire_network' if @search_criteria.scope_of_search == nil

    # default mode to basic
    @search_criteria.search_mode = 'basic'

    # track certification
    @search_criteria.board_certified = params['board_certified'] unless params['board_certified'] == nil

    render :partial=>"/shared/basic_search_form"
  end

  def toggle_advanced_mode
    # package up search params
    @search_criteria = SearchCriteria.new
    @search_criteria.from_search_fields( params['search'] )

    # track scope of search
    @search_criteria.scope_of_search = params['network']

    # default scope to entire_network
    @search_criteria.scope_of_search = 'entire_network' if @search_criteria.scope_of_search == nil

    # default mode to advanced
    @search_criteria.search_mode = 'advanced'

    # track certification
    @search_criteria.board_certified = params['board_certified'] unless params['board_certified'] == nil

    render :partial=>"/shared/advanced_search_form"
  end
end
