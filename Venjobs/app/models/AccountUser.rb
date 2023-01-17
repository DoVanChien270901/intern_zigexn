require 'carrierwave/orm/activerecord'
class AccountUser < ApplicationRecord
  enum :roles, %i[user admin]
  has_many :applied_jobs
  has_many :favorites
  has_many :applies
  has_one :curriculum_vitae
  has_many :histories
  devise :database_authenticatable, :registerable, :recoverable, :confirmable
  mount_uploader :cv, CvUploader
  validates :full_name, presence: {
    message: 'Full name is required!'
  }
  validates :encrypted_password, presence: {
                                   message: 'Password is required!'
                                 },
                                 length: {
                                   minimum: 8,
                                   message: 'Password\'s between 8 to 12 characters!'
                                 }
  validates :email, format: {
    with: URI::MailTo::EMAIL_REGEXP,
    message: 'Format email is valid!'
  }
  validate :validate_cv
  def validate_cv
    return if cv.file.nil?
    errors.add(:cv, 'File size must be less than 5 MB!') if (cv.file.size / 1_000_000.0).round(2) > 5
    ext_list = ['.doc', '.pdf', '.xls', '.xlsx', '.zip']
    return if ext_list.include? File.extname(cv.file.original_filename)
    errors.add(:cv, 'Format file invalid, allow format doc, pdf, xls, xlsx, zip!')
  end
end

