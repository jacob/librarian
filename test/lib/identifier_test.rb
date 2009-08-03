$LOAD_PATH << File.join(File.dirname(__FILE__) + "/../")
require 'test_helper'
require 'recording'
require 'yaml'

#put files to test in here, 
EXAMPLE_FILE_DIR = File.join(File.dirname(__FILE__) + "/../example_files")

class IdentifierTest < ActiveSupport::TestCase

  test "ensure we get some smoke from identifier command" do
    smoke = Identifier.exec_identifier_cmd(File.join(File.dirname(__FILE__) + "/../test_helper.rb"))
    assert_match /tag information/i, smoke.join
  end

  test "identify all recordings in example file directory" do
    check_sample_files

    Find.find(EXAMPLE_FILE_DIR) do |filepath|
      next if File.directory?(filepath) || !Recording.acceptable_recording?(filepath) || File.extname(filepath) == ".yml"

      #ensure yaml file exists
      if File.exists?(filepath + ".yml")
        puts "Testing identification of #{File.basename(filepath)}"

        answers = YAML.load(File.read(filepath + ".yml"))
        test = Identifier.tags_for(filepath)

        answers.each do |key,answer|
          if answer && !answer.strip.empty?
            assert_equal answer.strip, test[key.to_sym].to_s.strip
          end
        end

        answers = nil
      end
      

    end
  end


  def check_sample_files
    unless File.directory?(EXAMPLE_FILE_DIR)
      raise "No example file directory #{EXAMPLE_FILE_DIR}"
    end

    @example_file_count = 0

    Find.find(EXAMPLE_FILE_DIR) do |filepath|
      next if File.directory?(filepath)
      next unless File.exists?(filepath + ".yml")
      @example_file_count += 1
    end

    if @example_file_count == 0
      raise "Found no example files to test in #{EXAMPLE_FILE_DIR}, add some sample files and corresponding .yml answer files please"
    end
  end

end
