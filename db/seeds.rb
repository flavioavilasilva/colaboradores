# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

role_regular = Role.create!({ name: 'Regular', description: 'Can read items' })

role_admin = Role.create!({ name: 'Admin', description: 'Can perform any CRUD operation on any resource' })

user_admin = User.create!({ name: 'Admin', email: 'admin@admin.com', password: 'admin1', password_confirmation: 'admin1', role_id: role_admin.id })

user_regular = User.create!({ name: 'Sue', email: 'sue@example.com', password: '123456', password_confirmation: '123456', role_id: role_regular.id })

puts "------------ Dados iniciais criados com sucesso! ------------"
