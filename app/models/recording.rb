require 'uri'

class Recording < ActiveRecord::Base

  belongs_to :repository
  named_scope :active, :conditions => {:deleted => false}

  def file_ext
    file.split('.').last
  end

  def file_abbrev(len=100)
    if file.length > len
      file[0,len-1] + "---(#{file_ext})"
    else
      file
    end
  end

  def folder
    path.split('/').last[0,40]
  end

  def full_path
    File.join(path, file)
  end

  def escaped_path
    path.split('/').map {|item| URI.escape(item)}.join('/')
  end

  def url
    "http://" + repository.base_ftp + escaped_path + '/' + URI.escape(file)
  end
  
  def ftp_url
    "ftp://" + repository.base_ftp + full_path
  end

  def uploaded_at
    created_at.strftime("%m-%d-%Y--%I:%M%p")
  end

  def self.acceptable_recording?(path)
    return false if File.basename(path) =~ /^\./
    return false unless path =~ /\.(mp3|flac|ogg|wav)$/i
    true
  end

  def self.import_file(repo,relative_path,refresh=false)
    path = repo.base_path + relative_path
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
      rec.repository_id = repo.id
      rec.path = dirpath.smash_to_utf8
      rec.file = filename.smash_to_utf8
    end

    #set new recording's fields from ID3 tags
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

  # exclude pesky binary fields in ID3 tags
  def raw_tag_info=(val)
    arr = val.split("\n")
    arr.delete_if {|x| x.match("APIC") || x.match("POPM")}
    self[:raw_tag_info] = arr.join("\n")
  end

  def mark_as_deleted!
    self.deleted = true
    self.deleted_at = Time.now
    self.save!
  end

  def self.verify_files_exist!    
    Recording.active.each do |rec| #note that this is not paginated and will cause memory bloat
      unless File.readable?(rec.full_path)
        puts "#{rec.title} is gone!"
        rec.mark_as_deleted!
      end
    end
  end

end
