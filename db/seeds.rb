# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'open-uri'

page = Nokogiri::HTML.parse(open('https://www.vnnic.vn/tenmien/hotro/danh-s%C3%A1ch-c%C3%A1c-t%E1%BB%89nh-th%C3%A0nh-v%C3%A0-th%C3%A0nh-ph%E1%BB%91?lang=en')); nil
cities = page.at("table").text.gsub("\n\t\t\t", ",").gsub("\n", ",").partition("Các tỉnh,Thành phố,").last.split(",")
cities.each do |city|
  City.create!(name: city, region: "Việt Nam")
end
