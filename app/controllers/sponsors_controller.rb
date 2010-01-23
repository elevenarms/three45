class SponsorsController < ApplicationController
  before_filter :login_required
  before_filter :load_default_profile
  before_filter :load_target_sponsor

  def show
    begin
      TagSponsorClick.create!({ :tag_sponsor_id=>@target_sponsor.id, :user_id=>current_user.id})
    rescue=> e
      logger.error("SponsorsController") { "Error during creation of tag_sponsor_clicks: #{e}" }
    end
    redirect_to "#{@target_sponsor.link_url}"
  end
end
