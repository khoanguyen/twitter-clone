# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

template =  { name: "Khoa Nguyen", 
              username: "minhkhoa4783", 
              email: "minhkhoa4783@gmail.com", 
              password: "p@ss4now",
              #encrypted_password: "$2a$10$85Rm5NAsc6NQYcujifqH8ecSMEwS2vHirKEn2PQOLeIR3lhflW/LS", 
              about: "Me !!!", location: "San Jose", website: "", 
              avatar: "", cover: "", reset_password_token: nil, 
              reset_password_sent_at: nil, remember_created_at: nil, sign_in_count: 1, 
              current_sign_in_at: "2016-05-07 15:49:03", last_sign_in_at: "2016-05-07 15:49:03", 
              current_sign_in_ip: "127.0.0.1", last_sign_in_ip: "127.0.0.1", 
              confirmation_token: nil, confirmed_at: "2016-05-07 15:48:28", 
              confirmation_sent_at: "2016-05-07 15:48:22", created_at: "2016-05-07 15:48:22", 
              updated_at: "2016-05-07 15:53:30", slug: "minhkhoa4783", tweets_count: 0, 
              followers_count: 0, following_count: 0 }

40.times do |n|
  data = template.clone
  data[:name] = "Khoa Nguyen #" + n.to_s
  data[:slug] = "minhkhoa" + n.to_s
  data[:username] = "minhkhoa" + n.to_s
  data[:email] = "minhkhoa4783@gmail.com" + n.to_s
  
  puts data
  
  User.create!(data)
end
