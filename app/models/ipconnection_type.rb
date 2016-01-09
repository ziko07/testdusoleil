class IpconnectionType < ActiveRecord::Base
  self.table_name = "ipconnection_types"
  def self.find_by_ip ip
    w, x, y, z = ip.split('.').map{|b| b.to_i}
    ipnum = w*(256**3) + x*(256**2) + y*256 + z
    connection_type = where("? >= start_ip", ipnum).order("start_ip desc").limit(1).first
    connection_type if connection_type.present? and connection_type.end_ip >= ipnum
  end
end
