#!/usr/bin/env ruby

path = ARGV[0]
unless path
  puts "usage: script/scan_file.rb /path/to/file [force]"
  exit(-1) 
end
unless File.readable?(path)
  puts "#{path} is not a directory"
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

unless Recording.acceptable_recording?(path)
  puts "#{path} is not an 'acceptable' recording"
  exit(-1) 
end

REPORT_PROGRESS = path
start_time = Time.now

#do the scan
Recording.import_file(path,refresh)

stop_time = Time.now
puts "Finished scanning #{path}, elapsed time #{stop_time - start_time} seconds"
puts "Refreshed all tags" if refresh
