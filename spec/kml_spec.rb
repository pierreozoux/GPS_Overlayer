require 'spec_helper'

class TestKml < Test::Unit::TestCase
  def setup
  	FileUtils.cp("test/test.kml","test/current.kml")
  	$current_kml = Kml.new("test/current.kml")
  end

  def teardown
  	FileUtils.remove_file("test/current.kml")
  end

  def test_Kml_initialize
  	assert_equal Kml, $current_kml.class
  	assert_equal "test/current.kml", $current_kml.file
  end

  def test_Kml_track
    assert_equal Array, $current_kml.track.class
  end
end
