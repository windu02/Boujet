# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts 'SUPER ADMIN'
superadmin = AdminUser.create!({    :email => ENV['SUPERADMIN_EMAIL'].dup,
                                :password => ENV['SUPERADMIN_PASSWORD'].dup,
                                :password_confirmation => ENV['SUPERADMIN_PASSWORD'].dup
                         })
puts 'super admin: ' << superadmin.email

