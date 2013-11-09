class Manager < ActiveRecord::Base
  belongs_to :seller
  belongs_to :role
  belongs_to :branch
  
  attr_accessible :hashed_password, :name, :salt, :role_id, :seller_id, :password, :password_confirmation, :firstname, :lastname, :email, :address, :branch_id, :phone_no

  EMAIL_REGEX = /^[A-Z0-9._%+-]+@[A-Z0-9._]+\.[A-Z]{2,4}$/i
  validates :email,:length=>{:maximum=>100}, :format=>EMAIL_REGEX,:confirmation=>true

  validates :name, :branch_id, :presence => true, :uniqueness => true
  validates :password, :confirmation => true
  validates :firstname, :lastname, :address, :branch_id, :phone_no, :presence=>true

  attr_accessor :password_confirmation
  attr_reader :password
  validate :password_must_be_present
  
  def Manager.authenticate(name, password)
	if manager = find_by_name(name)
		if manager.hashed_password == encrypt_password(password, manager.salt)
		manager
		end
	end
  end
  
  def Manager.encrypt_password(password, salt)
	Digest::SHA2.hexdigest(password + "JESUS" + salt)
  end

  def password=(password)
	@password = password
	if password.present?
		generate_salt
		self.hashed_password = self.class.encrypt_password(password, salt)
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
