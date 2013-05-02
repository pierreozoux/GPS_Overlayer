require 'spec_helper'

class TestKmz < Test::Unit::TestCase
  def setup
  	FileUtils.cp("test/test.kmz","test/current.kmz")
  	$current_kmz = Kmz.new("test/current.kmz")
  end

  def teardown
  	FileUtils.remove_file("test/current.kmz")
  end

  def test_Kmz_initialize
  	assert_equal Kmz, $current_kmz.class
  	assert_equal "test/current.kmz", $current_kmz.path
  end

  def test_Kmz_track
    $current_kmz.init_track
    assert_equal Array, $current_kmz.track.class
  end
end
