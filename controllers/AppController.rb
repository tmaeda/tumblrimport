#
#  AppController.rb
#  tumblrimport
#
#  Created by tmaeda on 09/09/16.
#  Copyright (c) 2009 tmaeda. All rights reserved.
#

require 'osx/cocoa'
require 'uri'
require 'sqlite3'


include OSX
class AppController < NSWindowController
  POLLING_INTERVAL = 1.hour
#  POLLING_INTERVAL = 1.minute
  FETCH_INTERVAL = 1.day
#  FETCH_INTERVAL = 60.seconds
  LAST_UPDATED_KEY = "Last updated".freeze
  ROOT = File.join(File.expand_path("~"), "Library", "Caches", "Metadata", "tumblrimport").freeze
  include OSX
  kvc_accessor :sites
  def init
    if super_init
      ActiveRecordConnector.connect_to_sqlite_in_application_support :always_migrate => true, :log => true
      @sites = Site.find(:all).to_activerecord_proxies
      @queue = NSOperationQueue.alloc.init
      @importer = TumblrImporter.new
      @importer.add_observer(self)
      @timer = nil
      return self
    end
  rescue
    NSLog("AppController#init #{$!} #{$@.join("    \n")}")
  end

  def applicationDidFinishLaunching(sender)
    self.schedulePolling
  end

  ib_action :runNow
  def runNow(sender)
    defaults = NSUserDefaults.standardUserDefaults
    defaults[LAST_UPDATED_KEY] = nil
    defaults.synchronize
    run
  end

  def schedulePolling
    run
    app = self
    @timer = Timer.new(POLLING_INTERVAL) do
      app.run
    end
  end

  def run
    NSLog("polling")
    unless @importer.running?
      goal = self.lastUpdated + FETCH_INTERVAL
      current = Time.now
      NSLog("goal: #{goal}  current: #{current}")
      if goal < current
        Thread.start(@importer) do
          @importer.importTo(ROOT)
        end
      end
    else
      NSLog("importer is running. skipped.")
    end
  end

  def saveDefaults
    defaults = NSUserDefaults.standardUserDefaults
    defaults[LAST_UPDATED_KEY] = Time.now
    defaults.synchronize
    NSLog("wrote: defaults[LAST_UPDATED_KEY]: #{Time.now}")
  end

  def update(args)
    saveDefaults
  end

  # 最後に取得した日時を求める
  # @return [Time]
  def lastUpdated
    defaults = NSUserDefaults.standardUserDefaults
    last_updated = defaults[LAST_UPDATED_KEY] ? defaults[LAST_UPDATED_KEY].to_ruby : FETCH_INTERVAL.ago
    if last_updated > Time.now
      # 無いと思うけど、万が一last_updatedが未来だったらそれは何かの間違いなので補正しとく
      last_updated = FETCH_INTERVAL.ago
    end
    last_updated
  end

  def application_openFile_(app, path)
    tumblr_post = YAML.load_file(path)
    NSWorkspace.sharedWorkspace.openURL_(NSURL.URLWithString_(tumblr_post.url));
  end

end
