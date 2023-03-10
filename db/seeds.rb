# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

user = User.create(email: "kianreiling@gmail.com", password: "test1234", role: :admin)
Post.create(title: "First Post", content: "This is the first post", user: user)

second_user = User.create(email: "test@test.com", password: "test1234", role: :user)
