class History < ApplicationRecord
  belongs_to :account_user
  belongs_to :job
  validates :account_user_id, uniqueness: { scope: :job_id }
end
