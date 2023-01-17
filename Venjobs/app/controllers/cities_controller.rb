class CitiesController < ApplicationController
  def show
    @cities_vietnam = Province.select(:name, :count_job).where('country = ? and count_job >= 1', 'VietNam')
    @cities_international = Province.select(:name, :count_job).where('country = ? and count_job >= 1', 'International')
  end
end
