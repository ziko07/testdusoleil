# class AdminController < ApplicationController
#   # before_filter :authenticate
#   before_filter :authenticate_user!
#
#   # protected
#   # def authenticate
#   #   password = Sysconfig.singleton.admin_password
#   #   password_hash = Digest::SHA1.hexdigest(password)
#   #   return if session[:authenticated] == password_hash
#   #   if authenticate_with_http_digest {|username| password}
#   #     session[:authenticated] = password_hash
#   #   else
#   #     request_http_digest_authentication
#   #   end
#   # end
# end
