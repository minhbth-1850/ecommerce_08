categories = []
5.times do |n|
  name = Faker::Name.name + "-#{n+1}"
  parent_id = n > 0 ? categories[n - 1].id : nil
  categories << Category.create!(name: name,
                            parent_id: parent_id)
end

products = []
99.times do |n|
  name  = Faker::Name.name
  info = Faker::Company.name
  quantity = Faker::Number.between(10, 100)
  price = Faker::Number.between(10, 100)
  category = categories.sample.id
  image = nil
  rank = Faker::Number.between(10, 50).to_f / 10
  products << Product.create!(name: name,
                              info: info,
                              quantity: quantity,
                              price: price,
                              category_id: category,
                              image: image,
                              rank: rank,
                              activated: true)
end

users = []
99.times do |n|
  name  = Faker::Name.name
  email = "user-#{n+1}@gmail.com"
  password = "password"
  phone = "0132467981"
  address = "FHome, Da Nang"
  users << User.create!(name: name,
                        email: email,
                        password: password,
                        password_confirmation: password,
                        phone: phone,
                        address: address)
end

orders = []
5.times do |n|
  user_id = users.sample.id
  phone = "0132467981"
  address = "FHome, Da Nang"
  name  = Faker::Name.name
  orders << Order.create!(user_id: user_id,
                          phone: phone,
                          address: address,
                          reciever_name: name)
end

order_products = []
20.times do |n|
  order_id = orders.sample.id
  product_id = products.sample.id
  quantity = Faker::Number.between(1, 10)
  order_products << OrderProduct.create!(order_id: order_id,
                                          product_id: product_id,
                                          quantity: quantity)
end

# user admin
User.create!(name: "naruto",
             email: "naruto@gmail.com",
             password: "123456",
             password_confirmation: "123456",
             phone: "0132467981",
             address: "Leaf Village",
             role: 1)
