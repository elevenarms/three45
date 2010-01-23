require 'digest/sha1'

#
# Represents a user account within the system.
#
#
# Based on the RESTful Authentication generator.
#
#
class User < ActiveRecord::Base
  uses_guid
  has_many :user_groups
  has_one :workgroup_user
  has_one :dashboard_filter
  has_one :registration
  has_one :profile

  # Virtual attribute for the unencrypted password
  attr_accessor :password

  validates_presence_of     :login  #, email  (removed)
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login, :case_sensitive => false   #email removed
  # validates_length_of       :email,    :within => 3..100  (removed)

  before_save :encrypt_password

  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :password, :password_confirmation, :first_name, :middle_name, :last_name, :fax_number

  def full_name
    full_name = ''

    full_name += first_name + ' ' unless first_name == nil
    full_name += middle_name + ' ' unless middle_name == nil
    full_name += last_name unless last_name == nil

    full_name
  end

  def last_first
    full_name = ''

    full_name += last_name unless last_name == nil
    full_name += ', '+first_name unless first_name == nil
    full_name +=  ' '+middle_name unless middle_name == nil

    full_name
  end

  def load_groups_deep
    user_groups.find(:all, :include=>[:user, { :group => { :group_roles => [:role, :group] } } ])
  end

  # loads the default profile for this user, either as a user-level profile or the workgroup-level profile
  def load_default_profile(workgroup)
    workgroup_id = workgroup.nil? ? "9999999" : workgroup.id
    profile = Profile.find(:first, :conditions=>["user_id = ? or workgroup_id = ?",self.id, workgroup_id], :order=>"user_id DESC, workgroup_id DESC")
    #if there is no profile for either user or workgroup, we assume that this is a solo practice and the logged in person is
    # NOT a physician.  We find the profile of the physician and return it.
    #This may become an issue later if the profile is used to determine logged_in user capabilities, but right now it is
    #necessary because the Search system DEMANDS there be a profile.  --Brownell 7/24/08
    if workgroup_id != "9999999" && profile.nil? then
      workgroup_users = WorkgroupUser.find(:all, :conditions=> "workgroup_id = '#{workgroup_id }' ")
      x = 0
      while profile.nil? && !workgroup_users[x].nil? do 
        profile = Profile.find(:first, :conditions=> "user_id = '#{workgroup_users[x][:user_id] }' ")
        x += 1
      end
    end
    return profile
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find_by_login(login) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{login}--#{remember_token_expires_at}") #changed to login from email
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

  def logged_in!
    self.last_login_at = Time.now.utc
    self.save!
  end

  def has_logged_in?
    return !self.last_login_at.nil?
  end

  def is_physician?
    user_groups.each do |ug|
      return true if ug.physician?
    end
    return false
  end

  def join_groups
    self.user_groups.collect { |ug| ug.group_id }.join(",")
  end

  protected
    # before filter
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end

    def password_required?
      crypted_password.blank? || !password.blank?
    end

end
