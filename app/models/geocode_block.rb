class GeocodeBlock < ActiveRecord::Base
  belongs_to :geocode_location

  def self.find_by_ip ip
   unless ip.present?
     w, x, y, z = ip.split('.').map{|b| b.to_i}
     ipnum = w*(256**3) + x*(256**2) + y*256 + z
     geocode_block = where("? >= start_ipnum", ipnum).order("start_ipnum desc").limit(1).first
     geocode_block if geocode_block.present? and geocode_block.end_ipnum >= ipnum
   end
  end

  def self.load_csv
    database = Rails.configuration.database_configuration[Rails.env]['database']
    password = Rails.configuration.database_configuration[Rails.env]['password']
    system "sh script/db/geocode.sh #{database} '-uroot --password=#{password}' "
  end
end

