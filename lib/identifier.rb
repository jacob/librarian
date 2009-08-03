
class Identifier

  # Hullo, what id3tag
  TAGCMD = 'id3info' unless defined?(TAGCMD)
  raise "No cmd found for id3tag" unless `which #{TAGCMD}`

  def self.tags_for(filepath)
    get_hash_from_raw_id3_tag( exec_identifier_cmd(filepath) )
  end

  def self.exec_identifier_cmd(filepath)
    cmd = %Q!#{TAGCMD} '#{filepath.gsub(' ','\ ')}'!
    puts "running cmd #{cmd}"
    %x{ #{cmd} }
  end

  def self.get_hash_from_raw_id3_tag(val)
    ret = {:raw_results_string => val}
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

end
