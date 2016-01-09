class IplocationdbOrganization < ActiveRecord::Base
  self.table_name = "iplocationdb_organization"
  def self.find_by_ip ip
    w, x, y, z = ip.split('.').map{|b| b.to_i}
    ipnum = w*(256**3) + x*(256**2) + y*256 + z
    organization = where("? >= start_ip", ipnum).order("start_ip desc").limit(1).first
    organization if organization.present? and organization.end_ip >= ipnum
  end
end

