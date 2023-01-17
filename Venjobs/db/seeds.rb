# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require 'json'
file = File.read('vendor/local.json')
local_hash = JSON.parse(file)
cities = local_hash.map do |item|
  City.new(code: item['code'], name: item['name'])
end
City.import cities, on_duplicate_key_ignore: [:name], validate: false
