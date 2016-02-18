ActiveAdmin.register Tracker do
  # filter :"campaigns" , :as => :select, :collection => Campaign.all.collect {|o| [o.description, o.id]}
  # filter :"user" , :as => :select, :collection => User.all.collect {|o| [o.email, o.id]}
  # filter :"domain"
  # filter :"ip"
  form partial: 'form'

  index do
    column :domain
    column :ip
    column 'Assigned To' do |t|
      t.user.email if t.user.present?
    end
    column do |t|
      span link_to 'Edit', edit_admin_tracker_path(t)
      span link_to 'Assigned', edit_admin_tracker_path(t) unless t.user.present?
      span link_to 'Unassigned', unassigned_admin_tracker_path(t) if t.user.present?
    end
  end


  # form do |f|
  #   # f.inputs "Trackers Details" do
  #   #   f.input :domain
  #   #   f.input :ip
  #   #   f.input :user_id, :label => 'Member', :as => :select, :collection => User.all.map{|u| [u.email, u.id]}
  #   # end
  #   # f.actions
  #   columns do
  #     column do
  #       panel 'Form' do
  #
  #       end
  #     end
  #
  #     column do
  #       span "May 28, 2014 - 1 2 3 4, #= require active_admin/base ... Finally, considering our sample model Project , create the projects admin panel: 1, rails generate active_admin:resource Project ... 1 2 3, action_item only: :index do link_to 'Quick add', ... remote: true) do |f| .form-inputs = f.input :name = f.input :client ul.form-actions li ..."
  #     end
  #   end
  #
  # end


  # form do |f|
  #   f.inputs "Trackers Details" do
  #       f.input :domain
  #       f.input :ip
  #       f.input :user_id, :label => 'Member', :as => :select, :collection => User.all.map{|u| [u.email, u.id]}
  #   end
  #   f.actions
  # end


  member_action :unassigned, method: :get do
    tracker = Tracker.find_by_id(params[:id])
    tracker.user_id = 'NULL'
    tracker.save
    redirect_to admin_tracker_path, notice: "Successfully Unassigned"
  end

end
