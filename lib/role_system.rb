#
# Provides helper methods for performing security checks within the application, using the Group and Role models
# associated to the current User.
#
#
#
module RoleSystem

  #
  # Accepts an array of string or symbols with the role IDs to perform the check against
  #
  # returns true if the user has at least one role, false otherwise
  #
  def current_user_has_role?(role_ids_or_syms)
    # 1. create a single array of strings to perform our check against
    if !role_ids_or_syms.kind_of?(Array)
      required_role_ids = [role_ids_or_syms.to_s]
    else
      required_role_ids = role_ids_or_syms.collect { |r| r.to_s }
    end

    # 2. see if any of the user's roles match any of the required role ids
    user_role_ids = current_user_role_ids
    required_role_ids.each do |required_role_name|
      return true if user_role_ids.include?(required_role_name)
    end

    # 3. no role found
    return false
  end

  #
  # Accepts an array of string or symbols with the role IDs to perform the check against
  #
  # yields to the block if the user has at least one role from the list, or ignores otherwise
  #
  def current_user_has_role(role_ids_or_syms, &block)
    yield block if current_user_has_role?(role_ids_or_syms)
  end

  protected

  def current_user_role_ids
    roles = current_user_roles
    return roles.collect { |r| r.id }
  end

  def current_user_roles
    if logged_in?
      if !@current_user_roles
        # if the user is logged in, load the user's groups and associated roles in one query, then save as an instance
        # variable for in-memory lookups for future calls within the same request (controller instance)
        @current_user_groups = current_user.load_groups_deep
        @current_user_roles = Array.new
        @current_user_groups.each do |user_group|
          @current_user_roles += user_group.group.group_roles.collect { |gr| gr.role }
        end
      end
      return @current_user_roles
    end

    return []
  end
end
