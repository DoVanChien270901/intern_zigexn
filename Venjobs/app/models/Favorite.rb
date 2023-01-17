class Favorite < ApplicationRecord
  has_many :account_users
  validates :job_id, uniqueness: { scope: :account_user_id }
end

