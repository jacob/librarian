#!/usr/bin/env ruby

puts "Verifying recordings in database still exist on disk"

# load the app
RAILS_ENV = ENV['RAILS_ENV'] ||= 'development'
RAILS_ROOT = File.expand_path(File.dirname(__FILE__) + '/../')
require RAILS_ROOT + '/config/environment'

start_time = Time.now

#do the scan
Recording.verify_files_exist!

stop_time = Time.now
puts "Finished verifying recordings, elapsed time #{stop_time - start_time} seconds"
