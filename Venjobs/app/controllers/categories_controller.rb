class CategoriesController < ApplicationController
  def show
    @category_list = Category.select(:title, :count_job).where('count_job >= 1')
  end
end
