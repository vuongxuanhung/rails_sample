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

	private
		def downcase_email
			self.email = email.downcase
		end
end
