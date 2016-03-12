require 'flickraw'

class Photo
  attr_reader :info, :source, :page, :height, :width, :location

  def initialize pid
    # Auth variables
    FlickRaw.api_key = '725b6f8d1aeed52d5875c8e4e1f4e2b7'
    FlickRaw.shared_secret = '0fa0c9dc44cd5a70'

    @info = flickr.photos.getInfo(photo_id: pid)

    get_size
    set_location
  end

  def lat
    return @info['location']['latitude']
  end

  def lon
    return @info['location']['longitude']
  end

  # Sets name of photo location
  def set_location
    location = flickr.places.findByLatLon(lat: lat, lon: lon)
    location.size >= 1 ? @location = location.first['name'] : @location = "Unidentifiable location"
  end

  # Gets the appropriately sized version of the photo (i.e. not the 6500 x 4000 original)
  def get_size
    img_sizes = flickr.photos.getSizes(photo_id: @info['id']).to_a
    img = img_sizes.last

    # Loop down through images until appropriate sized one is found
    (img_sizes.length-2).downto(0) do |i|
      if img_sizes[i]['height'].to_i < 1000 || img_sizes[i]['width'].to_i < 1600
        img = img_sizes[i+1]
        break
      end
    end

    @source = img['source']
    @page = img['url']
    @height = img['height']
    @width = img['width']
  end
end