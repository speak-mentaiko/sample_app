class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  before_save { email.downcase! }

  validates :name, presence: true, length: { maximum: 50 }
  validates(
    :email,
    presence: true,
    length: { maximum: 255 },
    format: { with: URI::MailTo::EMAIL_REGEXP },
    uniqueness: true
  )
  validates :password, presence: true, length: { minimum: 8 }

  has_secure_password
end
