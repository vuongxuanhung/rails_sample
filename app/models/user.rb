class User < ActiveRecord::Base
	attr_accessor :remember_token
	before_save :downcase_email
	validates :name, presence: true, length: {maximum: 100}
	VALID_EMAIL = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, length: { maximum: 255},
					format: { with: VALID_EMAIL },
					uniqueness: { case_sensitive: false }
	has_secure_password
	validates :password, length: { minimum: 6 }

	def create_digest(string)
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    	BCrypt::Password.create(string, cost: cost)
	end

	def new_token
		SecureRandom.urlsafe_base64
	end

	def remember
		self.remember_token = new_token
		update_attribute(:remember_digest, create_digest(remember_token))
	end

	def authenticated?(remember_token)
		BCrypt::Password.new(remember_digest).is_password?(remember_token)
	end

	def forget
		update_attribute(:remember_digest, nil)
	end

	private
		def downcase_email
			self.email = email.downcase
		end
end
