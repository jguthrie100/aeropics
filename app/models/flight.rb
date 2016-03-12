require 'json'
require 'open-uri'

class Flight
  attr_reader :flight_data

  def initialize flight_id
    load_flight flight_id
  end

  def load_flight flight_id
    # Load data from flightradar24.com
    data_src = JSON.load(open("http://www.flightradar24.com/balance.json")).first[0]
    @flight_data = JSON.load(open("http://#{data_src}/_external/planedata_json.1.3.php?f=#{flight_id}"))
  end

  def lat
    return @flight_data['trail'][0]
  end

  def lon
    return @flight_data['trail'][1]
  end

  def flight_data
    return @flight_data
  end
end