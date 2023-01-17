class City < ApplicationRecord
  has_many :jobs
  validates :name, presence: true
  # validates :name, with: [!@#$%^&*(),.?":{}|<>'0-9]
  validates :name, format: { with: /[!@#$%^&*(),.?":{}|<>'0-9]/ }
end

