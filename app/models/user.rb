class User < ApplicationRecord
    has_secure_password

    #validations
    validates :username, presence: true, uniquness: true
    validates :email, presence: true, uniqueness: true, format: {with: URI::MailTo::EMAIL_REGEXP }
end
