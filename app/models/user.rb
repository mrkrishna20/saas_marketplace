class User < ApplicationRecord
    has_secure_password

    has_one :company, dependent: :destroy
    enum :role, { user: 0, admin: 1 }

    validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :name, presence: true
end
