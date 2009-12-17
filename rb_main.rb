#
#  rb_main.rb
#  tumblrimport
#
#  Created by tmaeda on 09/09/13.
#  Copyright (c) 2009 tmaeda. All rights reserved.
#
require 'osx/cocoa'
require 'rubygems'
gem 'activerecord', "2.2.2"
require 'osx/active_record'
require 'active_support'
require 'yaml_waml'

#require 'ruby-debug'
#Debugger.wait_connection = true
#Debugger.start_remote

def rb_main_init
  path = OSX::NSBundle.mainBundle.resourcePath.fileSystemRepresentation
  rbfiles = Dir.entries(path).select {|x| /\.rb\z/ =~ x}
  rbfiles -= [ File.basename(__FILE__) ]
  rbfiles.each do |path|
    require( File.basename(path) )
  end
end

if $0 == __FILE__ then
  begin
    rb_main_init
    OSX.NSApplicationMain(0, nil)
  rescue
    OSX::NSLog("#{$!} #{$@.join("     \n")}")
  end
end
