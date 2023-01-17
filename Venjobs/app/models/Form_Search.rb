class FormSearch < SimpleForm::FormBuilder
  @cities, @categories = []
  @email, @city, @cate , @from_date, @to_date = ''
  def initialize(cities, categories)
    @cities = cities
    @categories= categories
  end
end
