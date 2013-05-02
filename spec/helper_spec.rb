require 'spec_helper'

class TestHelper < Test::Unit::TestCase
  def setup
    FileUtils.cp("test/test.kmz","test/current.kmz")
    $current_kmz = Kmz.new("test/current.kmz")
  end

  def teardown
    FileUtils.remove_file("test/current.kmz")
  end
  
  def test_create_working_env
  	create_working_env $current_kmz.path
  	Dir.chdir(File.dirname($current_kmz.path))
  	Dir.exist?(File.basename($current_kmz.path),"kmz").should eql true
  end
end
