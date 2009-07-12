#!/usr/bin/env ruby

startpoint = ARGV[0]
unless startpoint
  puts "usage: script/scan_files.rb startpoint [force]"
  exit(-1) 
end
unless File.directory?(startpoint)
  puts "#{startpoint} is not a directory"
  exit(-1) 
end

#refreshing will re-read the ID3 tags for existing records
refresh = false
if ARGV[1] && 'force' == ARGV[1]
  refresh = true
end

# load the app
RAILS_ENV = ENV['RAILS_ENV'] ||= 'development'
RAILS_ROOT = File.expand_path(File.dirname(__FILE__) + '/../')
require RAILS_ROOT + '/config/environment'

REPORT_PROGRESS = true
start_time = Time.now

#do the scan
Recording.import_directory(startpoint,refresh)

stop_time = Time.now
puts "Finished scanning #{startpoint}, elapsed time #{stop_time - start_time} seconds"
puts "Refreshed all tags" if refresh
