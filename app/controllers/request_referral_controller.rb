class RequestReferralController < ApplicationController
  before_filter :login_required
  before_filter :load_default_profile

  RESULTS_PER_PAGE = 10

  #
  # Performs an initial search query to initialize the referring workgroup selection process
  # for a new request referral
  #
  # See StartReferralController for the standard referral entry point
  #
  def show
    # pagination support
    @search_criteria = SearchCriteria.new

      @page_number = (params[:page_number] || "1").to_i
    @offset = @page_number == 1 ? nil : (@page_number-1) * RESULTS_PER_PAGE
    @friendships, @total_pages, @profile_results = execute_friendship_search(RESULTS_PER_PAGE, @offset)
    @context = "request_referral"

    # See ticket #86 - for now, conduct a basic search with no filter criteria when starting a new
    #                  referral
    #@page_number = (params[:page_number] || "1").to_i
    #@offset = @page_number == 1 ? nil : (@page_number-1) * RESULTS_PER_PAGE
    #@profile_results, @total_pages, @friendships = execute_network_search(RESULTS_PER_PAGE, @offset, @search_criteria)
    #render :template=>'start_referral/show'

    redirect_to hash_for_request_referral_search_path.merge({ :context=>"request_referral"})
  end
end
