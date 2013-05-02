require 'rubygems'
require 'rmagick'

def get_images kmz_file

  init_kml kmz_file

  kmz_file.track.each_with_index do |tuple,index|

    lat = Float(tuple[1])
    long = Float(tuple[0])



    bottom = "http://denishain.fr/Marker/bottom.png"
    top = "http://denishain.fr/Marker/top.png"
    left = "http://denishain.fr/Marker/left.png"
    right = "http://denishain.fr/Marker/right.png"

    zoom = 0.0040

    top_lat = lat + zoom
    bottom_lat = lat - zoom
    left_long = long - zoom
    right_long = long + zoom




    marker_top =    "&markers=shadow:false%7Cicon:#{top}%7C#{top_lat},#{long}"
    marker_bottom = "&markers=shadow:false%7Cicon:#{bottom}%7C#{bottom_lat},#{long}"
    marker_left =   "&markers=shadow:false%7Cicon:#{left}%7C#{lat},#{left_long}"
    marker_right =  "&markers=shadow:false%7Cicon:#{right}%7C#{lat},#{right_long}"

    address_api = "http://maps.googleapis.com/maps/api/staticmap?size=640x640&sensor=false&maptype=satellite&format=png"

    address = "#{address_api}#{marker_top}#{marker_right}#{marker_bottom}#{marker_left}"

    image_name = "overlay#{index}.png"
    image_path = File.join(kmz_file.img_path,image_name)

    cmd = "wget '#{address}' -O #{image_path}"
    #`#{cmd}`

    #crop_red image_path
		
		add_overlay_to_kml kmz_file,index,top_lat,bottom_lat,left_long,right_long

  end

  doc_xml_path = File.join(File.dirname(kmz_file.path),File.basename(kmz_file.path,".kmz"),"doc.kml")

  f = File.new(doc_xml_path, "w")
  f.write(XmlSimple.xml_out(kmz_file.doc_xml))

  p kmz_file.doc_xml
end

def add_overlay_to_kml kmz_file,index,top_lat,bottom_lat,left_long,right_long

	overlay = {
		'name' => ["image-#{index}"],
		'Icon' => [{
			'href' => ["files/overlay_#{index}.png"],
			'viewBoundScale' => [0.75]
		}],
		'LatLonBox' => [{
			'north' => [top_lat],
			'south' => [bottom_lat],
			'east' => [right_long],
			'west' => [left_long],
			'rotation' => [0]
			}]
		}
		
	
	kmz_file.doc_xml['Document'][0]['Folder'][0]['GroundOverlay'] << overlay
end

def init_kml kmz_file
	groundoverlay = {
	  'GroundOverlay' => []
	}

	kmz_file.doc_xml['Document'][0]['Folder'][0].merge!(groundoverlay)

end


def crop_red path
	nb_pixel = 0
	
	Magick::Image.read(path)[0].each_pixel do |pixel, col, row|
		if pixel.red > 230 and pixel.green < 10 and pixel.blue < 10
			nb_pixel = nb_pixel + 1

			if nb_pixel == 1
				@top = row + 4
			end

			if nb_pixel == 51
				@left = col + 4
			end

			if nb_pixel == 56
				@right = col
			end

			if nb_pixel == 151
				@bottom = row
			end
		end

	end

	p @top
	p @left
	p @right
	p @bottom

	x = @left + 1
	y = @top + 1
	width = @right - @left - 1
	height = @bottom - @top - 1

	Magick::ImageList.new(path).crop!(x,y,width,height).write(path)

end