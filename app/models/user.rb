class User < ActiveRecord::Base
  # after_update :send_password_change_email, if: :needs_password_change_email?
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  attr_accessor :unhashed_password
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,:is_admin
  has_many :campaigns
  has_many :trackers

  private

  # def needs_password_change_email?
  #   encrypted_password_changed? && persisted?
  # end
  #
  # def send_password_change_email
  #   CampaignMailer.password_changed(id).deliver
  # end

  def password_required?
    new_record? ? super : false
  end
end
