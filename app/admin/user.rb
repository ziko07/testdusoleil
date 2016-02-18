ActiveAdmin.register User do
  # filter :"campaigns" , :as => :select, :collection => Campaign.all.collect {|o| [o.description, o.id]}
  # filter :"email"
  # filter :"is_admin"

  index do
    column :id
    column :email
    column :is_admin
    column :sign_in_count
    column :current_sign_in_ip
    column :last_sign_in_ip
    actions defaults: true do |u|
      link_to "Login As this User", login_as_admin_user_path(u), :target => '_blank'
    end
  end

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :is_admin
    end
    f.actions
  end

  member_action :login_as, :method => :get do
    user = User.find(params[:id])
    sign_in(user, bypass: true)
    redirect_to campaigns_path
  end
end
