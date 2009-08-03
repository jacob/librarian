$LOAD_PATH << File.join(File.dirname(__FILE__) + "/../")
require 'test_helper'

class RecordingTest < ActiveSupport::TestCase

  test "acceptable recordings" do
    assert !Recording.acceptable_recording?("/var/file/.dsoijfdsoifjdsofi.mp3")
    assert !Recording.acceptable_recording?(".dsoijfdsoifjdsofi.mp3")
    assert !Recording.acceptable_recording?("._dsoijfdsoifjdsofi.mp3")
    assert Recording.acceptable_recording?("dsoijfdsoifjdsofi.mp3")
    assert Recording.acceptable_recording?("dsoijfd s  oifjdsofi.flac")
    assert Recording.acceptable_recording?("dsoijfds  oif  jdsofi.ogg")
    assert Recording.acceptable_recording?("dsoijfdsoifjdsofi.MP3")
    assert Recording.acceptable_recording?("dsoijfd s  oifjdsofi.FLAC")
    assert Recording.acceptable_recording?("dsoijfds  oif  jdsofi.OGG")
  end

end
