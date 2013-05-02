require 'xmlsimple'

class Kml
  attr_reader :file, :track, :doc_xml

  def initialize(file)
  	@file = file
    @doc_xml = XmlSimple.xml_in(file)
  end

  def track
  	str_track = self.doc_xml['Document'][0]['Folder'][0]['Placemark'][0]['LineString'][0]['coordinates'][0]
	  str_track.delete! "\n"
	  str_track.delete! "\t"
	  @track = str_track.split "0 "
	  @track.collect! {|elt| elt.split ","}
	  return @track
	end
end
