class Product < ApplicationRecord
  belongs_to :company
  
  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :company_id, presence: true
end
