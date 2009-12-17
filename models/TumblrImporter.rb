#
#  TumblrImporter.rb
#  tumblrimport
#
#  Created by tmaeda on 09/09/13.
#  Copyright (c) 2009 tmaeda. All rights reserved.
#

require 'tumblr4r'
require 'observer'

class TumblrImporter
  include OSX
  include Observable

  def initialize
    @running = false
  end

  def running?
    @running
  end

  def importTo(dest_path)
    @running = true
    sites = Site.find(:all)
#    Tumblr4r::Site.default_log_level = Logger::DEBUG
    sites.each do |record|
      host = URI.split(record.url)[2]
      NSLog("fetching host: #{host}")
      site = Tumblr4r::Site.new(host)
      posts = site.find(:all)
      dir_path = "#{dest_path}/#{host}"
      if File.directory?(dir_path)
        FileUtils.rm_r(dir_path)
      end
      FileUtils.mkdir_p(dir_path)
      posts.each do |post|
        File.open("#{dir_path}/#{post.post_id}.tumbi", "wb") do |f|
          f.write post.to_yaml
        end
      end
    end
    self.changed
    self.notify_observers(nil)
  rescue
    NSLog("Error: #{$!} #{$@.join("     \n")}")
  ensure
    @running = false
  end
end
