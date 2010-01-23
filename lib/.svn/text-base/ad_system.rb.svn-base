#
# Ad rendering support for the user interface, driven from the ads table
#
#
module AdSystem

  #
  # Supports the rendering of ads to the user based on the ads table data. Ads are currently
  # targeted to a specific workgroup using the active_target of the current referral.
  # Ad selection is made by selecting the first Ad found that matches the referral's target workgroup id.
  #
  # If an Ad is found, a new AdView row is created.
  #
  # If an Ad is not found as a match, an HTML comment is embedded in the HTML source for debugging
  # purposes.
  #
  #
  def render_ad
    @target_ad = nil

    # 1. determine if we have an ad to show
    if @target_referral and !@target_referral.active_target.nil? and !@target_referral.active_target.workgroup.nil?
      target_workgroup_id = @target_referral.active_target.workgroup_id
      @target_ad = Ad.find_ad_for_workgroup(target_workgroup_id)
    end

    if @target_ad
      # 2. Mark a new AdView into the DB
      begin
        AdView.create!({ :ad_id=>@target_ad.id, :user_id=>current_user.id})
      rescue => e
        logger.error("AdSystem") { "Error during creation of ad_view: #{e}" }
      end

      # 3. Render the HTML for the Ad
      return link_to(image_tag(@target_ad.image_path), ad_url(@target_ad))
    end

    return "<!-- No Ad Matched -->"
  end
end
