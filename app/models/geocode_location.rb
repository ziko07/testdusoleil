class GeocodeLocation < ActiveRecord::Base
  has_many :geocode_blocks
  belongs_to :geocode_metro_code
end
