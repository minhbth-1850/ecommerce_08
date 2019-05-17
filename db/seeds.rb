cates = []
5.times do |n|
  name = Faker::Name.name + "-#{n+1}"
  parent_id = n > 0 ? cates[n - 1].id : nil
  cates << Category.create!(name: name,
                            parent_id: parent_id)
end

99.times do |n|
  name  = Faker::Name.name
  info = Faker::Company.name
  quantity = Faker::Number.between(10, 100)
  price = Faker::Number.between(1, 10) * 100000
  category = cates.sample.id

  Product.create!(name: name,
                  info: info,
                  quantity: quantity,
                  price: price,
                  category_id: category)
end

99.times do |n|
  name  = Faker::Name.name
  email = "user-#{n+1}@gmail.com"
  password = "password"
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password)
end
