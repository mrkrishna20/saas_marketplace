class Company < ApplicationRecord
  belongs_to :user
  has_many :products, dependent: :destroy
  has_many :clients, through: :company_clients
  has_many :company_clients, dependent: :destroy
  
  validates :name, presence: true
  validates :user_id, uniqueness: true
end
