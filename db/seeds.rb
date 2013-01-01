# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts 'SUPER ADMIN'
superadmin = AdminUser.new({    :email => ENV['SUPERADMIN_EMAIL'].dup,
                                :password => ENV['SUPERADMIN_PASSWORD'].dup,
                                :password_confirmation => ENV['SUPERADMIN_PASSWORD'].dup
                         })
superadmin.save
puts 'super admin: ' << superadmin.email

puts 'CONFIG VARS'
pettycash = Config.create({ :key => "pettycash", :value => "0" })
puts 'config vars: ' << pettycash.key + ' with value: ' + pettycash.value
keptfees = Config.create({ :key => "keptfees", :value => "20" })
puts 'config vars: ' << keptfees.key + ' with value: ' + keptfees.value