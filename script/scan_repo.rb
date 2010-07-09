#!/usr/bin/env ruby
#
# Scans repo directory for new files to add to db
#

# load the app
RAILS_ENV = ENV['RAILS_ENV'] ||= 'development'
RAILS_ROOT = File.expand_path(File.dirname(__FILE__) + '/../')
require RAILS_ROOT + '/config/environment'

# refuse to work if no repo
unless repo = Repository.first
  puts "Error: no repository configured. First make a new repo in the db then this can go"
  exit(-1)
end

# refuse to work if repo not readable
unless File.directory?(repo.base_path) && File.readable?(repo.base_path)
  puts "Error: repository not readable: #{repo.base_path}"
  exit(-1)
end

# refuse to work if repo is a symlink (TODO FIX!!!)
#unless File.symlink?(repo.base_path)
#  puts "Error: repository can not be a symlink: #{repo.base_path}"
#  exit(-1)
#end


# TODO: remove scan_files.rb and scan_file.rb

#refreshing will re-read the ID3 tags for existing records
refresh = false
if ARGV[0] && 'force' == ARGV[0]
  refresh = true
  puts "Force refresh enabled" 
  sleep 2
end

puts "Scanning repo based in #{repo.base_path}"

REPORT_PROGRESS = repo.base_path
start_time = Time.now

#do the scan
repo.scan!(refresh)

stop_time = Time.now
puts "Finished scanning #{repo.base_path}, elapsed time #{stop_time - start_time} seconds"
puts "Refreshed all tags" if refresh

