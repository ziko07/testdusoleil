# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
# IplocationdbOrganization.destroy_all
# require 'csv'
# file_path = File.join(Rails.root, 'db', 'geoiporg.csv')
# file =  File.read(file_path).force_encoding('BINARY').encode('UTF-8', :invalid => :replace, :undef => :replace, :replace => '?')
# CSV.parse(file).each do |row|
#   prefix = row[0].to_i >> 24 
#   text = row[2]
#   IplocationdbOrganization.create(:prefix => prefix, :start_ip => row[0], :end_ip => row[1], :organization => text)
#   p ">>> created row >>> #{row}"
# end
user = User.create(email: 'testdusoleil@gmail.com', password: '123456789', confirm_password: '123456789', is_admin:true)
puts("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<")
puts(user.inspect)
puts("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<")

# IpconnectionType.destroy_all
# require 'csv'
# file_path = File.join(Rails.root, 'db', 'ipconnection_type.csv')
# file =  File.read(file_path).force_encoding('BINARY').encode('UTF-8', :invalid => :replace, :undef => :replace, :replace => '?')
# CSV.parse(file).each do |row|
#   prefix = row[0].to_i >> 24
#   IpconnectionType.create(:prefix => prefix, :start_ip => row[0], :end_ip => row[1], :start_ip_addr => row[2], :end_ip_addr => row[3], :connection_type => row[4])
#   p ">>> created row >>> #{row}"
# end

