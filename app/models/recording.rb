#require 'TagLib'
require 'find'

class Recording < ActiveRecord::Base

  TAGCMD = 'id3info' unless defined?(TAGFCMD)


  def self.acceptable_recording?(path)
    return false if File.basename(path) =~ /^\./
    return false unless path =~ /\.(mp3|flac|ogg)$/i
    true
  end

  def self.import_directory(path,refresh=false)
    filename = File.basename(path)

    raise "could not find directory to import #{path}" unless File.directory?(path)
    puts "#{path}" if defined?(REPORT_PROGRESS)

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

    puts "   #{path}" if defined?(REPORT_PROGRESS)

    #check if file exists in db
    rec = Recording.find_by_file_and_path(filename,dirpath)
    if rec
      return rec if !refresh
    else
      rec = Recording.new 
      rec.path = dirpath 
      rec.file = filename
    end

    # Alas, TagLib...
    #tagref = TagLib::FileRef.new(path)
    #tag = tagref.tag

    # Hullo, what? id3tag
    raise "No cmd found for id3tag" unless `which #{TAGCMD}`
    cmd = "#{TAGCMD} #{path}"
    rec.raw_tag_info = %x{ #{cmd} }
    puts "RAW TAG IS #{rec.raw_tag_info.inspect}"
    

    tag = self.get_hash_from_raw_id3_tag(rec.raw_tag_info)
    puts "TAG IS #{tag.inspect}"

    rec.album = tag[:album]
    rec.artist = tag[:artist]
    rec.title = tag[:title]
    #rec.artist = (tag.artist && !tag.artist.empty?) ? tag.artist : nil
    #rec.title = (tag.title && !tag.title.empty?) ? tag.title : nil
    #rec.genre = (tag.genre && !tag.genre.empty?) ? tag.genre : nil
    #rec.year = (tag.year && tag.year > 0) ? tag.year : nil
    #rec.track = (tag.track && tag.track > 0) ? tag.track : nil

    #DEBUG
    #if album
    #  puts "album: #{album}  artist: #{artist} title: #{title} genre: #{genre} year: #{year} track: #{track}"
    #end

    rec.updated_at = Time.now # force updated_at even if tag data is unchanged
    rec.save!

    tag = nil
    # tagref = nil
  end

  def self.get_hash_from_raw_id3_tag(val)
    ret = {}
    arr = val.split('===')

    #album
    if row = arr.detect {|x| x =~ /(Album|Movie|Show)/i }
      album = row.split('):').last.to_s.strip
      if album && !album.strip.empty?
        ret[:album] = album
      end
    end

    #artist
    if row = arr.detect {|x| x =~ /Lead.performer/i }
      artist = row.split('):').last.to_s.strip
      if artist && !artist.strip.empty?
        ret[:artist] = artist
      end
    end

    #title
    if row = arr.detect {|x| x =~ /Title.songname/i }
      title = row.split('):').last.to_s.strip
      if title && !title.strip.empty?
        ret[:title] = title
      end
    end

    ret
  end

  def raw_tag_info=(val)
    arr = val.split('===')
    arr.delete_if {|x| x.match("APIC")}
    self[:raw_tag_info] = arr.join('===')
  end

end
