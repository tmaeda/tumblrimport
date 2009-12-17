#
#  timer.rb
#  Tumblrimport
#
#  Created by tmaeda on 09/05/19.
#  Copyright (c) 2009 tmaeda. All rights reserved.
#
require 'osx/cocoa'
class Object
  # The hidden singleton lurks behind everyone
  def metaclass; class << self; self; end; end
  def meta_eval &blk; metaclass.instance_eval &blk; end

  # Adds methods to a metaclass
  def meta_def name, &blk
    meta_eval { define_method name, &blk }
  end

  # Defines an instance method within a class
  def class_def name, &blk
    class_eval { define_method name, &blk }
  end
end

class Timer
  include OSX
  def initialize(interval, &block)
    meta_def(:ring, &block)
    @interval = interval
    ObjectSpace.define_finalizer(self, Proc.new{ @timer.invalidate if @timer })
    reset
  end

  def start
    unless @timer
      reset
    end
  end

  def stop
    if @timer
      @timer.invalidate
      @timer = nil
    end
  end

  def fire
    @timer.fire
  end

  private
  def reset
    if @timer
      @timer.invalidate
      @timer = nil
    end
    @timer = NSTimer.scheduledTimerWithTimeInterval_target_selector_userInfo_repeats(@interval, self, 'ring:', nil, true)
  end
end


if $0 == __FILE__
  class AppDelegate < OSX::NSObject
    def applicationDidFinishLaunching(notification)
      puts "finish"
      a = Timer.new(1){ puts "aaa"}
      a.start

      b = Timer.new(2){ puts "bbb"}
      b.start
    end
  end

  $delegate = AppDelegate.alloc.init
  app = OSX::NSApplication.sharedApplication
  app.setDelegate($delegate)
  app.run
end
