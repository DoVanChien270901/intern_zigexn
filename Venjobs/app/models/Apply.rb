class Apply < ApplicationRecord
  require 'csv'
  belongs_to :account_user
  belongs_to :job
  mount_uploader :cv, CvUploader
  validates :full_name, length: {
    maximum: 200,
    message: 'Full name max 200 character!'
  }, presence: { message: 'Full name is required!' }
  validates :email, format: {
    with: URI::MailTo::EMAIL_REGEXP,
    message: 'Format email is valid!'
  }
  validates :account_user_id, uniqueness: { scope: :job_id, message: 'You have submitted your CV for this job!' }
  def self.export(jobs)
    CSV.generate(col_sep: ',') do |csv|
      csv << attribute_names
      jobs.find_each do |item|
        csv << item.attributes.values
      end
    end
  end
end
