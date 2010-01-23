#
# Helper methods for the Rails environment
#
#
#
module RailsSystem
  def development?
    return RAILS_ENV == "development"
  end

  def staging?
    return RAILS_ENV == "staging"
  end

  def production?
    return RAILS_ENV == "production"
  end
end
