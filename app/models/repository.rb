require 'find'

class Repository < ActiveRecord::Base
  has_many :recordings

  def scan!(refresh=false)
    Find.find(base_path) do |filepath|
      if File.directory?(filepath)
        puts "Scanning Directory :#{filepath}:"        
      elsif Recording.acceptable_recording?(filepath)
        relative_path = filepath.sub(base_path,'')
        Recording.import_file(self, relative_path, refresh)
      end
    end
  end

end
