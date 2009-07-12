require 'TagLib'
class Recording < ActiveRecord::Base

  def self.acceptable_recording?(path)
    path =~ /\.(mp3|flac|ogg)$/i
  end

  def self.import_directory(path,refresh=false)
    filename = File.basename(path)
    return false if ['..','.'].include?(filename)

    raise "could not find directory to import #{path}" unless File.directory?(path)
    puts "#{path}" if defined?(REPORT_PROGRESS)

    Dir.foreach(path) do |file|
      filepath = File.join(path,file)
      
      if self.acceptable_recording?(filepath)
        self.import_file(filepath,refresh)
      elsif File.directory?(filepath)
        self.import_directory(filepath,refresh)
      end

    end

  end

  def self.import_file(path,refresh=false)
    filename = File.basename(path)
    dirpath = File.dirname(path)
    raise "could not find file to import #{path}" unless File.readable?(path)

    puts "   #{filename}" if defined?(REPORT_PROGRESS)

    #check if file exists in db
    rec = Recording.find_by_file_and_path(filename,dirpath)
    if rec
      return rec if !refresh
    else
      rec = Recording.new 
      rec.path = dirpath 
      rec.file = filename
    end

    #get tag
    tagref = TagLib::FileRef.new(path)
    tag = tagref.tag

    rec.album = (tag.album && !tag.album.empty?) ? tag.album : nil
    rec.artist = (tag.artist && !tag.artist.empty?) ? tag.artist : nil
    rec.title = (tag.title && !tag.title.empty?) ? tag.title : nil
    rec.genre = (tag.genre && !tag.genre.empty?) ? tag.genre : nil
    rec.year = (tag.year && tag.year > 0) ? tag.year : nil
    rec.track = (tag.track && tag.track > 0) ? tag.track : nil

    #DEBUG
    #if album
    #  puts "album: #{album}  artist: #{artist} title: #{title} genre: #{genre} year: #{year} track: #{track}"
    #end

    rec.updated_at = Time.now # force updated_at even if tag data is unchanged
    rec.save!

    tag = nil
    tagref = nil
  end

end
