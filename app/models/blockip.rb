require 'tempfile'

class Blockip < ActiveRecord::Base
  REMOTE_SOURCE = 'fantomaster'
  @@gen = -1
  @@ips = nil

  after_create :bump_gen

  def remote?
    [REMOTE_SOURCE, 'autorun'].include? source
  end

  def self.poll
    transaction do
      database = Rails.configuration.database_configuration[Rails.env]['database']
      password = Rails.configuration.database_configuration[Rails.env]['password']
      system "sh script/db/blockip.sh fantomaster #{database} '-uroot --password=#{password}' "
      delete_all(['source = ?', REMOTE_SOURCE])
      connection.execute "INSERT INTO blockips (ip, source) SELECT ip, source FROM blockips_updates"
      raise ActiveRecord::Rollback if where(:source => REMOTE_SOURCE).count == 0
      bump_gen
    end
  end

  def bump_gen
    self.class.bump_gen
  end

  def self.bump_gen
    Rails.cache.fetch("dusoleil.blockips.gen", :raw => true) { "0" }
    Rails.cache.increment("dusoleil.blockips.gen")
  end

  def self.blocked?(ip,user_id= '')
    # unless @@gen == (gen = Rails.cache.read("dusoleil.blockips.gen", :raw => true))
    #   @@gen = gen
    #   @@ips = Rails.cache.fetch("dusoleil.blockips/#@@gen") do
    #     Blockip.connection.select_values("select ip from blockips").inject({}) do |hash, val|
    #       hash[val] = true unless val.blank?; hash
    #     end
    #   end
    # end
    # return @@ips.include?(ip)
    if user_id != ''
      ip = Blockip.connection.select_values("select ip from blockips where ip = '#{ip}' and user_id = '#{user_id}'").last
    else
      ip = Blockip.connection.select_values("select ip from blockips where ip = '#{ip}'").last
    end
    return ip.present?

  end

  def self.destroy_ips(blockips)
    blockips.each {|b| b.destroy}
    bump_gen
  end
end
