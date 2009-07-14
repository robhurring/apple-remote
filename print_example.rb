require 'lib/apple_remote'

# Simple button mapping

play do
  puts "I'm playing... (Playing? #{playing?})"
end

pause do
  puts "I'm paused... (Playing? #{playing?})"
end

up do
  puts "I hit the volume-up button"
end

down do
  puts "I hit the volume-down button"
end

forward do
  puts "I hit the forward button"
end

back do
  puts "I hit the back button"
end

back do
  puts "I'm another back button callback, but only while playing!" if playing?
end

menu do
  puts "I hit the menu button!"
end