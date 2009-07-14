require 'lib/apple_remote'

# How to change OSX spaces using the remote and some osascript
# 
# Assuming you have 3 total spaces and you can use
# ^# (control+space_number) to get to that space

spaces = 3
current_space = 1
def goto(space)
`osascript<<EOS
    tell application "System Events"
    	tell process "Finder"
    		keystroke "#{space}" using control down
    	end tell
    end tell
EOS
`
end

forward do
  current_space += 1
  current_space = 1 if current_space > spaces
  goto current_space
end

back do
  current_space -= 1
  current_space = spaces if current_space < 1
  goto current_space
end
