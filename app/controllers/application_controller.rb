class ApplicationController < ActionController::Base
  # protect_from_forgery
  def authenticate_current_user!
    unless current_user.present? && current_user.is_admin
      redirect_to user_session_path
    end
  end

  def after_sign_in_path_for(resource)
    if current_user.present? && current_user.is_admin
      admin_root_path
    else
      campaigns_path
    end
  end

  def after_inactive_sign_up_path_for(resource)
    puts("Here")
    user_session_path
  end

  def after_sign_out_path_for(resource)
    user_session_path
  end

  helper_method :authenticate_current_user!
end
