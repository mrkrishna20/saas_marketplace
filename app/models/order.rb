class Order < ApplicationRecord
  belongs_to :client
  belongs_to :product
  belongs_to :company
  
  validates :client_id, presence: true
  validates :product_id, presence: true
  validates :company_id, presence: true
  validates :status, presence: true, inclusion: { in: ['pending', 'completed', 'cancelled'] }
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  
  scope :by_status, ->(status) { where(status: status) }
  scope :recent, -> { order(created_at: :desc) }
  
  def complete!
    update!(status: 'completed')
  end
  
  def cancel!
    update!(status: 'cancelled')
  end
end
