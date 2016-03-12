require 'flickraw'

class Photo
  attr_reader :info, :source, :page, :height, :width

  def initialize pid
    # Auth variables
    FlickRaw.api_key = '725b6f8d1aeed52d5875c8e4e1f4e2b7'
    FlickRaw.shared_secret = '0fa0c9dc44cd5a70'

    @info = flickr.photos.getInfo(photo_id: pid)
    biggest_size
  end

  def lat
    return @info['location']['latitude']
  end

  def lon
    return @info['location']['longitude']
  end

  def location
    # Get name of photo location
    location = flickr.places.findByLatLon(lat: lat, lon: lon)
    location.size >= 1 ? (return location.first['name']) : (return "Unidentifiable location")
  end

#  def source
#    return "http://farm#{@info['farm']}.staticflickr.com/#{@info['server']}/#{@info['id']}_#{@info['secret']}_b.jpg"
#  end

#  def page
#    return "http://www.flickr.com/photos/#{@info['owner']['nsid']}/#{@info['id']}"
#  end

  def biggest_size
    biggest = flickr.photos.getSizes(photo_id: @info['id']).to_a.last
    @source = biggest['source']
    @page = biggest['url']
    @height = biggest['height']
    @width = biggest['width']
  end
end