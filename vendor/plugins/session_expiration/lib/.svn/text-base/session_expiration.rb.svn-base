module SessionExpiration
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    def expire_session_in(time, opts={})
      opts[:after_expiration] = opts[:after_expiration] || nil
      class_eval { prepend_before_filter Proc.new { |p| p.check_expiration(time, opts)} }
    end
  end
  
  def check_expiration(time, opts)
    if session[:expires_at] && is_expired?
      reset_session
      return self.send(opts[:after_expiration]) unless opts[:after_expiration].nil?
    end
    set_session_expiration(time)
  end
  
  protected    

  def set_session_expiration(time)
    session[:expires_at] = time.from_now
  end
  
  def is_expired?
    Time.now > session[:expires_at]
  end

end