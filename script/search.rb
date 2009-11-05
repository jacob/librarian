#!/usr/bin/env ruby

search_field = ARGV[0]
unless search_field
  puts "usage: script/search.rb [artist|album|title|file] search-terms"
  exit(-1) 
end
unless %W{ artist album title file }.include? search_field
  puts "#{search_field} is not a type of search field, try artist, album, title or file"
  exit(-1) 
end

search_term = ARGV[1].to_s.strip
unless search_term && !search_term.empty?
  puts "missing search terms"
  exit(-1)
end


# load the app
RAILS_ENV = ENV['RAILS_ENV'] ||= 'development'
RAILS_ROOT = File.expand_path(File.dirname(__FILE__) + '/../')
require RAILS_ROOT + '/config/environment'


start_time = Time.now

#do the search
recordings = Recording.active.find(:all, :conditions => ["#{search_field} ~* ?",search_term])

stop_time = Time.now

#oh boy, results!
puts "Finished searching for #{search_term} (#{stop_time - start_time}s) #{recordings.size} results"

recordings.each do |rec|
  puts "  Title: #{rec.title}"
  puts "  Artist: #{rec.artist}"
  puts "  Album: #{rec.album}"
  puts "  Filename: #{rec.file}"
  puts "  URL: #{rec.url}"
  puts "\n\n"
end


