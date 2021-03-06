class User < ActiveRecord::Base
  require 'digest/sha2'
  belongs_to :role

  attr_accessible :hashed_password, :name, :salt, :role_id, :password_confirmation, :firstname, :lastname, :address, :phone_no, :password
:password
  validates :name, :presence => true, :uniqueness => true
  validates :password, :confirmation => true
  validates :firstname, :lastname, :address, :phone_no, :presence=>true

  attr_accessor :password_confirmation
  attr_reader :password
  validate :password_must_be_present
  
  def User.authenticate(name, password)
	if user = find_by_name(name)
		if user.hashed_password == encrypt_password(password, user.salt)
		user
		end
	end
  end
  
  def User.encrypt_password(password, salt)
	Digest::SHA2.hexdigest(password + "JESUS" + salt)
  end

  def password=(password)
	@password = password
	if password.present?
		generate_salt
		self.hashed_password = self.class.encrypt_password(password, salt)
	end	
  end	

	def ensure_an_admin_remains
		if User.count.zero?
		raise "Can't delete last user"
	end
	end

  private
	
	def password_must_be_present
		errors.add(:password, "Missing password" ) unless hashed_password.present?
	end

	def generate_salt
		self.salt = self.object_id.to_s + rand.to_s
	end

end
