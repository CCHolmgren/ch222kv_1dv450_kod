# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Admin
User.create(username: "admin", password: "password", password_confirmation: "password", is_administrator: true, email: "@")
User.create(username: "ordinary_user", password:"password", password_confirmation:"password", is_administrator: false, email:"@")
otheruser = User.create(username: "otheruser", password:"password", password_confirmation:"password", is_administrator:false, email:"@")

# Create some tags
["great", "decent", "awful", "been-there-done-that", "what-now"].each do |name|
  Tag.create(name: name)
end

admin = User.find_by_username("admin")
ordinary_user = User.find_by_username("ordinary_user")
event = Event.create(user:ordinary_user, short_description: "This is my short description", description: "This should be a longer one", name:"Test name", latitude: 13.032, longitude: -15.0321)
# Ugly add some tags
event.tags << Tag.limit(3)
Event.create(user:ordinary_user, short_description:"This is some other description", description: "What is this field now?", name:"Some good event", latitude: 59.326940, longitude: 18.077694)
events = [{
              user: admin,
              short_description: "Something",
              description: "Whatnowdsadsad",
              name: "Eventname",
              latitude: 80.03231,
              longitude: 120.0329,
          },
          {
              user: ordinary_user,
              short_description: "Is it me you're looking for?",
              description: "Hello, hello?",
              name: "My event is better than yours",
              latitude: 12.2312,
              longitude: 15.0293,
          },
          {
              user: ordinary_user,
              short_description: "Shorter than me",
              description: "Longer than you are",
              name: "A name here",
              latitude: 23.102,
              longitude: -12.0329,
          },
          {
              user: otheruser,
              short_description: "What are you talking about",
              description: "Nothing really",
              name: "Event here, yes",
              latitude: 80.03231,
              longitude: 121.0329,
          }]
events.each do |new_event|
  Event.create(new_event)
end