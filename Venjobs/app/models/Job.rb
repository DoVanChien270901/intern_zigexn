class Job < ApplicationRecord
  belongs_to :category
  belongs_to :level
  belongs_to :province
  belongs_to :work_placement
  has_many :applies
  has_many :favorites
  validates :description, :name, presence: true
  searchable do
    long :id, as: :id_l, stored: true
    text :name, as: :name_acs, boost: 9
    text :benefit, as: :benefit_acs, boost: 4
    text :company_address, as: :company_address_acs, boost: 5
    text :company_name, as: :company_name_acs, boost: 6
    text :description, as: :description_acs, boost: 8
    text :requirement, as: :requirement_acs, boost: 3
    text :category_title, as: :category_title_acs, boost: 2 do |j|
      j.category.title
    end
    text :province_name, as: :province_name_acs, boost: 3 do |j|
      j.province.name
    end
    string :description_unikey, as: :description_unikey do |j|
      "#{j.name} #{j.description} #{j.benefit} #{j.requirement}"
    end
  end
end
