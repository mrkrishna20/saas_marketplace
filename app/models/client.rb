class Client < ApplicationRecord
  has_secure_password
  has_many :company_clients, dependent: :destroy
  has_many :companies, through: :company_clients
  
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, format: { with: /\A\d{10}\z/, message: "must be exactly 10 digits and contain only numbers" }, allow_blank: true
end
