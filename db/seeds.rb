# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

20.times do |n|
  email = "minatosnow#{n + 2}@gmail.com"
  name = Faker::Name.name
  fname = name.split.last
  lname = name.split[0..-2].join(" ")
  password = "123123"
  password_confirmation = "123123"
  User.create!(email: email,
               fname: fname,
               lname: lname,
               password: password,
               password_confirmation: password_confirmation)
end

20.times do |n|
  user = User.find_by_id(n + 2)
  Request.create!(job_id: n + 1,
                  fname: user.fname,
                  lname: user.lname,
                  email: user.email,
                  cv: Faker::File.file_name)
end
