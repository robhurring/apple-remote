require 'lib/apple_remote'

# This really only works with volume buttons.. and it is pretty bad at that.

up(:down) do
  puts "volume button is down."
end

up(:up) do
  puts "volume button is released."
end