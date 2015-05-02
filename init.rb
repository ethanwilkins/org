# digital organics, learning, evolving, and multiplying

# library modules
require 'rbconfig'
require 'ipaddr'
require 'uri'

# org class
require './org'

# gets input string from user
puts "\nWhat is up:"
data = gets
puts "\n"

# creates new org with data
org = Org.new data

# org becomes alive
org.live
