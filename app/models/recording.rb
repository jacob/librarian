require 'find'
require 'uri'

class Recording < ActiveRecord::Base

  def self.acceptable_recording?(path)
    return false if File.basename(path) =~ /^\./
    return false unless path =~ /\.(mp3|flac|ogg)$/i
    true
  end

  def self.import_directory(path,refresh=false)
    filename = File.basename(path)

    raise "could not find directory to import #{path}" unless File.directory?(path)
    puts "#{path.sub(REPORT_PROGRESS,'')}" if defined?(REPORT_PROGRESS)

    Find.find(path) do |filepath|
      if File.directory?(filepath)
        puts "Scanning Directory :#{filepath}:"        
      elsif self.acceptable_recording?(filepath)
        self.import_file(filepath,refresh)
      end

    end

  end

  def self.import_file(path,refresh=false)
    filename = File.basename(path)
    dirpath = File.dirname(path)
    raise "could not find file to import #{path}" unless File.readable?(path)

    puts "   #{path.sub(REPORT_PROGRESS,'')}" if defined?(REPORT_PROGRESS)

    #check if file exists in db
    rec = Recording.find_by_file_and_path(filename.smash_to_utf8, dirpath.smash_to_utf8)
    if rec
      return rec if !refresh
    else
      rec = Recording.new 
      rec.path = dirpath.smash_to_utf8
      rec.file = filename.smash_to_utf8
    end


    tag_hash = Identifier.tags_for(path)
    rec.raw_tag_info = tag_hash[:raw_results_string]

    rec.album = tag_hash[:album]
    rec.artist = tag_hash[:artist]
    rec.title = tag_hash[:title]

    rec.updated_at = Time.now # force updated_at even if tag data is unchanged
    begin
      rec.save!
    rescue Exception => e
      RAILS_DEFAULT_LOGGER.error e.log_formatted
      puts "VVVVV=========ERROR==========VVVVVV"
      puts e.log_formatted
      puts "^^^^^==========ERROR==========^^^^^"
      # :P
    end

    tag_hash = nil
  end

  def raw_tag_info=(val)
    arr = val.split("\n")
    arr.delete_if {|x| x.match("APIC") || x.match("POPM")}
    self[:raw_tag_info] = arr.join("\n")
  end

  def escaped_path
    path.split('/').map {|item| URI.escape(item)}.join('/')
  end

  def url
    "ftp://example.com" + escaped_path + '/' + URI.escape(file)
  end

end
