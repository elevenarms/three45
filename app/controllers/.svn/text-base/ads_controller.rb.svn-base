class AdsController < ApplicationController
  before_filter :login_required
  before_filter :load_target_ad, :only=>[:show]

  def show
    # 1. Mark a new AdClick in the DB
    begin
      @ad_click = AdClick.create!({ :ad_id=>@target_ad.id, :user_id=>current_user.id})
    rescue => e
      logger.error("AdSystem") { "Error during creation of ad_view: #{e}" }
    end

    # 2. Send a redirect to the Ad.link_url
    redirect_to @target_ad.link_url

    # write tests
  end

end
