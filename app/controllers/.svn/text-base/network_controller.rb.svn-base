class NetworkController < ApplicationController
  before_filter :login_required
  before_filter :load_default_profile

  RESULTS_PER_PAGE = 10

  def show
    # pagination support
    @page_number = (params[:page_number] || "1").to_i
    @offset = @page_number == 1 ? nil : (@page_number-1) * RESULTS_PER_PAGE
    @search_criteria = SearchCriteria.new
    @friendships, @total_pages, @profile_results = execute_friendship_search(RESULTS_PER_PAGE, @offset)
    @context = "network"
  end
end
