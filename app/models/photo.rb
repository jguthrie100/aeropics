require 'flickraw'

class Photo
  attr_reader :info

  def initialize pid
    # Auth variables
    FlickRaw.api_key = '725b6f8d1aeed52d5875c8e4e1f4e2b7'
    FlickRaw.shared_secret = '0fa0c9dc44cd5a70'

    @info = flickr.photos.getInfo(photo_id: pid)
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

  def source
    return "http://farm#{@info['farm']}.staticflickr.com/#{@info['server']}/#{@info['id']}_#{@info['secret']}_b.jpg"
  end

  def page
    return "http://www.flickr.com/photos/#{@info['owner']['nsid']}/#{@info['id']}"
  end
end