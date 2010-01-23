class ProfilesController < ApplicationController
  before_filter :login_required
  before_filter :load_default_profile
  before_filter :load_target_profile

  def show
    @friendships = [ProfileFriendship.find_friendship_from_to(@profile, @target_profile)]
    if @target_profile.workgroup_profile?
      @phys_users = @target_profile.workgroup.find_physicians
      @physicians = @phys_users.collect { |phys_user| phys_user.load_default_profile(@target_profile.workgroup) }
    end
    @context = params[:context] || "network"
  end
end
