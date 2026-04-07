class CompanyClient < ApplicationRecord
  belongs_to :company
  belongs_to :client
  
  validates :name, presence: true
  validate :email_or_phone_must_be_present
  
  after_validation :generate_dummy_email, if: -> { email.blank? }
  
  # Override as_json to hide dummy emails
  def as_json(options = {})
    json = super(options)
    json['email'] = nil if dummy_email?
    json
  end
  
  def dummy_email?
    email&.match?(/user_.*@noemail\.com/)
  end
  
  private
  
  def email_or_phone_must_be_present
    if email.blank? && phone.blank?
      errors.add(:base, "At least one of email or phone must be present")
    end
  end
  
  def generate_dummy_email
    self.email = "user_#{SecureRandom.uuid}@noemail.com"
  end
end
