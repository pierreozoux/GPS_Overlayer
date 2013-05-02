require 'zip/zipfilesystem'
require './lib/kml.rb'

class Kmz
  attr_reader :path, :track, :img_path, :doc_xml

  def initialize(path)
  	@path = path
    @img_path = File.join(File.dirname(self.path),File.basename(self.path,".kmz"),"files")
    Zip::ZipFile.open(path, Zip::ZipFile::CREATE) do |zf|
      kml_file = Kml.new(zf.file.open("doc.kml", "r"))
      @track = kml_file.track
      @doc_xml = kml_file.doc_xml
    end
  end
  	
end
