require 'flickraw'

class PicsController < ApplicationController
  def show
    # Auth variables
    FlickRaw.api_key = '725b6f8d1aeed52d5875c8e4e1f4e2b7'
    FlickRaw.shared_secret = '0fa0c9dc44cd5a70'

    # Get URI parameters for flight_id and num_photos (which photo to select from list of returned photos)
    flight_id = params['flight_id']
    params['num_photos'].nil? ? num_photos = 1 : num_photos = params['num_photos'].to_i

    flight = Flight.new(flight_id)
    lat = flight.lat
    lon = flight.lon

    response = nil
    bbox = nil

    # Loop that increases size of bounding box on each iteration
    #  (useful when plane is over unpopulated areas and bounding box needs to search over a larger area for photos)
    (1..10).each do |i|

      # Get bounding box (limited to -80, -90, 180, 90)
      bbox = "#{[lon-(0.2*i), -180].max}, #{[lat-(0.2*i), -90].max}, #{[lon+(0.2*i), 180].min}, #{[lat+(0.2*i), 90].min}"
      
      # Search flickr for photos taken within bounding box
      response = flickr.photos.search(bbox: bbox, min_date_taken: '2000-01-01', sort: 'interestingness-desc', media: 'photos')
      if response.size >= num_photos
        break
      end
    end

    # Build array of Photos to send to View
    @photos = Array.new
    response.each do |p|
      break if @photos.size >= num_photos
      photo = Photo.new(p['id'])

byebug
      # Little exception that stops "facetheworld" photos being used - some random flickr account that has 100,000+ photos tagged in various remote locations
      next if photo.info['owner']['nsid'] == "100597270@N04"
      
      @photos.push photo
    end
  end
end
