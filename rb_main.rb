#
#  rb_main.rb
#  tumblrimport
#
#  Created by tmaeda on 09/09/13.
#  Copyright (c) 2009 tmaeda. All rights reserved.
#

# GEM_PATHを変更するほどには自前でgemを持ちたくないので、
# 必要な場所にのみパスを通す
COCOA_APP_RESOURCES_DIR = File.dirname(__FILE__)
$LOAD_PATH.unshift(File.join(COCOA_APP_RESOURCES_DIR, "RubyGems", "gems", "activesupport-2.2.2", "lib"))
$LOAD_PATH.unshift(File.join(COCOA_APP_RESOURCES_DIR, "RubyGems", "gems", "activerecord-2.2.2", "lib"))
$LOAD_PATH.unshift(File.join(COCOA_APP_RESOURCES_DIR, "RubyGems", "gems", "yaml_waml-0.3.0", "lib"))
require 'rubygems'
require 'activesupport'
require 'activerecord'
require 'logger'
require 'yaml_waml'
require 'osx/cocoa'
require 'osx/active_record'

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
