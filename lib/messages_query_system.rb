#
# Provides reusable query code necessary for the messages grid, which can be
# shared between the ReferralsController (which initializes the screen the grid
# is on) and the MessagesController (the primary RESTful controller for managing messages)
#
module MessagesQuerySystem

  RESULTS_PER_PAGE = 20

  #
  # Initializes a new MessageFilter, unless one is found within the current user session
  #
  #
  #
  def setup_messages_filter_from_session_or_request
    @filter = session[:message_filter] || MessageFilter.new
    @filter.referral_id = @target_referral.id

    # load values from request params
    @filter.page_number = (params[:page_number] || "1").to_i
    @filter.sort_field = params[:sort] || @filter.sort_field || "created"
    @filter.sort_order = params[:order] || @filter.sort_order || "desc"

    # save into the session (not in spec but following dashboard pattern)
    session[:message_filter] = @filter
  end

  #
  # Using the current message filter, perform a database search and filter query for
  # matching ReferralMessages
  #
  #
  def query_messages_using_filter
    @results, @total_pages = ReferralMessage.search_and_filter(@filter, RESULTS_PER_PAGE)
  end
end
