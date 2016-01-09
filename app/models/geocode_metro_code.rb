class GeocodeMetroCode < ActiveRecord::Base
  has_many :geocode_locations
end
