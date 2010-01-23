class FriendshipsController < ApplicationController
  before_filter :login_required
  before_filter :load_default_profile
  before_filter :load_target_profile, :only=>[:create]
  before_filter :load_target_friendship, :only=>[:block, :open]

  # no 'new' action    - there is no form for creating a new friendship (the link in the snippets is the form)
  # no 'update' action - there is no form for updating a friendship (the link in the snippets is the form)

  def create
    begin
      # 1. determine if this is already a friendship
      existing_friendship = ProfileFriendship.find_friendship_from_to(@profile, @target_profile)
      if !existing_friendship
        # 2. if not, create and save one
        @friendship = ProfileFriendship.create_bidirectional_friendship!(@profile, @target_profile)
      end

      # 3. send back the proper response
      if request.xhr? and @friendship
        render :layout=>false
      elsif request.xhr?
        render :text=>"" # send back an empty reply, nothing was done
      else
        redirect_to(network_url)
      end
    rescue => e
      handle_error("An error occurred when trying to create the friendship", e)
    end
  end

  def block
    begin
      @target_friendship.block!
      @target_profile = @target_friendship.target_profile
      # send back the proper response
      if request.xhr?
        render :layout=>false
      else
        redirect_to(network_url)
      end
    rescue => e
      handle_error("An error occurred when trying to update the friendship", e)
    end
  end

  def open
    begin
      @target_friendship.open!
      @target_profile = @target_friendship.target_profile
      # send back the proper response
      if request.xhr?
        render :layout=>false
      else
        redirect_to(network_url)
      end
    rescue => e
      handle_error("An error occurred when trying to update the friendship", e)
    end
  end
end
