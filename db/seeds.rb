# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# db/seeds.rb

articles = [
  'Sherlock Holmes',
  'House of the Dragon',
  'Breaking Bad',
  'Game of Thrones',
  'Iron Man',
  'Avengers Infinity War',
  'The Office',
  'How i met your mother',
  'The big bang theory',
  'Death Note',
  'Dragon Ball Super',
  'Hunter X Hunter',
  'What is a good car',
  'How is Emil Hajric doing'
]

articles.each do |title|
  Article.create(title: title)
end
