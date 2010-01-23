#
# Helper methods for network searching functionality. The network search
# functionality is spread across several controllers to support network searches
# as well as selecting a consultant or referring workgroup when creating a new
# referral. This module consolidates the search logic for each controller.
#
#
#
#
module SearchSystem

  def execute_friendship_search(limit=10, offset=nil)
    return ProfileFriendship.find_by_profile(@profile, limit, offset)
  end

  def execute_tag_search(tag_id, limit=10, offset=nil)
    # TODO: change the find_by_tag to sort by friendships first, then non-friends
    profiles, total_pages = Profile.find_by_tag(@profile, tag_id, limit, offset)
    profile_id_list = profiles.collect { |p| p.id }
    friendships = ProfileFriendship.find_in_list_for(@profile, profile_id_list)
    return friendships, total_pages, profiles
  end

  def execute_network_search(limit=10, offset=nil, criteria=nil)
    # build appropriate join clause
    join_clause  = ""

    where_clause = "( profiles.id <> '#{@profile.id}' )"

    unless criteria.display_name == nil || criteria.display_name.strip == 'Any' || criteria.display_name.strip == ''
      where_clause += " AND profiles.display_name LIKE '%#{criteria.display_name.strip}%'"
    end

    criteria.instance_variables.each do |v|
      next if v == '@search_mode'
      next if v == '@display_name'
      next if v == '@scope_of_search'

      vv = criteria.instance_variable_get(v).strip

      unless vv == nil || vv == '' || vv == 'Any'

        # strip leading @
        v = v[/[a-z_]+/]

        #
        # SQL Generation logic:
        #
        # For each SearchCriteria instance_variable that we are processing (aka tag that we want to filter on):
        #
        #   1. Generate a new INNER JOIN clause using an aliased profile_tags table specific for the tag
        #   2. Generate a new INNER JOIN clause using an aliased tags table specific for the tag
        #   3. Generate a conditional clause for the aliased joins using a 'like' conditional
        #
        profile_tag_join_alias = "#{v}_profile_tags"
        tag_join_alias = "#{v}_tags"

        join_clause  += " INNER JOIN profile_tags as #{profile_tag_join_alias} ON #{profile_tag_join_alias}.profile_id = profiles.id "
        join_clause  += " INNER JOIN tags as #{tag_join_alias} ON #{tag_join_alias}.id = #{profile_tag_join_alias}.tag_id"
        where_clause += " AND (#{tag_join_alias}.tag_type_id = '#{v}' AND #{tag_join_alias}.name LIKE '#{vv}%')"

      end
    end

    # now see if need to limit scope of search to profile's friends or profile's workgroup's friends
    if criteria.scope_of_search == 'my_network'
      where_clause += " AND profiles.id IN (SELECT target_profile_id FROM profile_friendships WHERE source_profile_id = '#{@profile.id}')"
    elsif criteria.scope_of_search == 'workgroup_network'
      workgroup_id = @profile.workgroup_id || WorkgroupUser.find_by_user_id( @profile.user_id).workgroup_id

      subsl_clause = "SELECT id FROM profiles WHERE workgroup_id = '#{workgroup_id}' OR user_id IN (SELECT user_id FROM workgroup_users WHERE workgroup_id = '#{workgroup_id}')"
      where_clause += " AND profiles.id IN (SELECT target_profile_id FROM profile_friendships WHERE source_profile_id IN (#{subsl_clause}))"
    end

    # do the lookup
    count = Profile.count( 'profiles.id', :conditions => where_clause ) unless !join_clause.empty?
    profiles = Profile.find( :all, :conditions => where_clause, :limit=>limit, :offset=>offset ) unless !join_clause.empty?

    count = Profile.count( 'profiles.id', :conditions => where_clause, :joins => join_clause ) if !join_clause.empty?
    profiles = Profile.find( :all, :conditions => where_clause, :limit=>limit, :offset=>offset, :joins => join_clause ) if !join_clause.empty?

    total_pages = (count / limit)
    total_pages += 1 if (count % limit) != 0
    total_pages = 1 if total_pages == 0

    return profiles, total_pages, ProfileFriendship.find_all_by_source_profile_id( @profile.id )
  end

  def render_search_form
    if @search_criteria.search_mode == 'advanced'
      render :partial=>"/shared/advanced_search_form"
    else
      render :partial=>"/shared/basic_search_form"
    end
  end

  # returns the friendship if the current profile (@profile) is already in a friendship with the target
  # Note: requires the @friendships array instance variable to be initialized by the controller already
  def profile_in_friendship_with(with_profile)
    return nil if !@friendships

    if !@quick_profile_friendships_hash
      # initialize a quick lookup hash based on the friendships
      @quick_profile_friendships_hash = @friendships.hash_by { |friendship| friendship.nil? ? nil : friendship.target_profile_id }
    end

    return @quick_profile_friendships_hash[with_profile.id].first if @quick_profile_friendships_hash[with_profile.id]
    return nil
  end

  def search_filters_to_hash(*args)
    options = args.last.is_a?(Hash) ? args.pop : {}
    include_page_number = options[:include_page_number] || false

    return { "search" => params[ 'search' ], "search_mode" => params[ 'search_mode' ] }
  end

end
