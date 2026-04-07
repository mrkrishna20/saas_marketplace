class Product < ApplicationRecord
  belongs_to :company
  
  validates :name, presence: true
  validates :company_id, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
