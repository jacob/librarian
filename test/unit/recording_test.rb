$LOAD_PATH << File.join(File.dirname(__FILE__) + "/../")
require 'test_helper'

class RecordingTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "acceptable recordings" do
    assert Recording.acceptable_recording?("dsoijfdsoifjdsofi.mp3")
    assert Recording.acceptable_recording?("dsoijfd s  oifjdsofi.flac")
    assert Recording.acceptable_recording?("dsoijfds  oif  jdsofi.ogg")
    assert Recording.acceptable_recording?("dsoijfdsoifjdsofi.MP3")
    assert Recording.acceptable_recording?("dsoijfd s  oifjdsofi.FLAC")
    assert Recording.acceptable_recording?("dsoijfds  oif  jdsofi.OGG")
  end


  test "id3tag example 0" do
     tag =  %Q!
*** Tag information for BAL.2009.05.29.SurgeonInShanghai.16.05.2009.mp3
=== TIT2 (Title/songname/content description): Surgeon - Void @ The Shelter,
=== TPE1 (Lead performer(s)/Soloist(s)): Surgeon
=== TYER (Year): 16
=== COMM (Comments): (ID3v1 Comment)[XXX]: www.dj-surgeon.com
*** mp3 info
MPEG1/layer III
Bitrate: 128KBps
Frequency: 44KHz
!


    hash = Recording.get_hash_from_raw_id3_tag(tag)

    #album
    assert_equal(nil, hash[:album])
    #artist
    assert_equal("Surgeon", hash[:artist])
    #title
    assert_equal("Surgeon - Void @ The Shelter,", hash[:title])
    
  end



  test "id3tag example 1" do
     tag =  %Q!
*** Tag information for Harmonia - Live at ATP NY.mp3
=== COMM (Comments): (iTunPGAP)[eng]: 0
=== TENC (Encoded by): iTunes 8.0.0.35
=== COMM (Comments): (iTunNORM)[eng]:  000000DD 00000000 0000568B 00000000 000EE7B6 00000000 000060C4 00000000 0009A4C6 00000000
=== COMM (Comments): (iTunSMPB)[eng]:  00000000 00000210 00000A74 0000000005C247FC 00000000 029C910F 00000000 00000000 00000000 00000000 00000000 00000000
=== TIT2 (Title/songname/content description): Live at ATP NY 2008 (TITLE)
=== TPE1 (Lead performer(s)/Soloist(s)): Harmonia
=== TALB (Album/Movie/Show title): Live at ATP NY 2008 (ALBUM)
=== TRCK (Track number/Position in set): 1/1
=== TPOS (Part of a set): 1/1
=== TYER (Year): 2008
=== COMM (Comments): (ID3v1 Comment)[XXX]: 0
*** mp3 info
MPEG1/layer III
Bitrate: 160KBps
Frequency: 44KHz
!


    hash = Recording.get_hash_from_raw_id3_tag(tag)

    #album
    assert_equal('Live at ATP NY 2008 (ALBUM)', hash[:album])
    #artist
    assert_equal("Harmonia", hash[:artist])
    #title
    assert_equal("Live at ATP NY 2008 (TITLE)", hash[:title])
    
  end



end
