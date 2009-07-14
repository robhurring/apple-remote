require 'osx/cocoa'
require 'pp'

OSX::NSBundle.bundleWithPath("/Library/Frameworks/AppleRemote.framework").load
OSX.ns_import(:AppleRemote)

module AppleRemote
  class AppleRemoteDelegate < OSX::NSObject
    addRubyMethod_withType('sendRemoteButtonEvent:pressedDown:remoteControl:', 'v@:ii@')  

    ButtonType = {
      16  => :play_pause,
      2   => :up,
      4   => :down,
      64  => :back,
      32  => :forward,
      8   => :menu
    }

    attr_reader :playing
    
    def initialize
      @callbacks = []
      @playing = false
    end
    
    def <<(callback)
      @callbacks << callback
    end
    
    def sendRemoteButtonEvent_pressedDown_remoteControl(buttonIdentifier, pressedDown, remoteControl)
      button = ButtonType[buttonIdentifier]
      @playing = !@playing if button == :play_pause && pressedDown == 1
      button = (playing ? :play : :pause) if button == :play_pause
      state = (pressedDown == 1 ? :down : :up)
      
      @callbacks.each do |callback|
        callback.handle if callback.can_handle?(button, state)
      end
    end    
  end  

  class Handler
    def initialize(type, state = :any, &callback)
      @type = type
      @state = state
      @callback = callback
    end
    
    def can_handle?(type, state)
      @type == type && (state == @state || @state == :any)
    end
    
    def handle(*args)
      @callback.call(*args)
    end
  end
  
  module DSL
    def self.included(base)
      @@remote_delegate = AppleRemote::AppleRemoteDelegate.alloc.init
      @@apple_remote = OSX::AppleRemote.alloc.initWithDelegate_(@@remote_delegate)
    end

    def listen!
      @@apple_remote.startListening 0
      OSX::NSApplication.sharedApplication.run
    end
    
    def playing?
      @@remote_delegate.playing
    end

    [:play, :pause, :up, :down, :forward, :back, :menu].each do |method|
      module_eval %{
        def #{method}(state = :down, &block)
          @@remote_delegate << Handler.new(:#{method}, state, &block)
        end
      }
    end
    
    at_exit { listen! }
  end
end

include AppleRemote::DSL

