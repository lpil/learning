require 'erb'

name = 'Tim'
years = 6
company = "Bob's Burgers"

document =
"This is the CV of <%= name %>

They worked for <%= years %> years at <%= company %>"

puts ERB.new(document).result
