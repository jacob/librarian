require "open3"
require 'iconv'

class Identifier

  # Hullo, what id3tag
  TAGCMD = 'id3info' unless defined?(TAGCMD)
  raise "No cmd found for id3tag" unless `which #{TAGCMD}`

  def self.tags_for(filepath)
    get_hash_from_raw_id3_tag( exec_identifier_cmd(filepath) )
  end

  def self.exec_identifier_cmd(filepath)
    stdin, stdout, stderr = Open3.popen3(TAGCMD, filepath)
    ret = stdout.readlines
    stdin, stdout, stderr = [nil,nil,nil]
    ret.each_index  do |i|
      ret[i] = ret[i].smash_to_utf8
    end
    ret 
  end

  def self.get_hash_from_raw_id3_tag(arr)
    ret = {:raw_results_string => arr.join("")}

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

end
