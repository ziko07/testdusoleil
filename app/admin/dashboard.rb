ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do
    # div :class => "blank_slate_container", :id => "dashboard_default_message" do
    #   span :class => "blank_slate" do
    #     span I18n.t("active_admin.dashboard_welcome.welcome")
    #     small I18n.t("active_admin.dashboard_welcome.call_to_action")
    #   end
    # end

    panel "User List" do
         table_for User.all do
           column :email
           column 'Campaign Created' do |u|
             u.campaigns.count
           end
           column 'Domain Assigned' do |u|
             u.trackers.count
           end
           column 'Daily Hit' do |u|
             # hit_list =  u.campaigns.map(&:get_avg)
             # (hit_list.sum.to_f / hit_list.size.to_f).round(2)
            Hit.where(created_at: Date.today.beginning_of_day..Date.today.end_of_day, campaign_id: u.campaigns.map(&:id)).count
           end

           column 'Monthly Hit' do |u|
             # hit_list =  u.campaigns.map(&:get_avg)
             # daily_avg = (hit_list.sum.to_f / hit_list.size.to_f).round(2)
             # daily_avg * 30
             Hit.where(created_at: Date.today.beginning_of_month..Date.today.end_of_month, campaign_id: u.campaigns.map(&:id)).count
           end
         end
         end

    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       ul do
    #         Post.recent(5).map do |post|
    #           li link_to(post.title, admin_post_path(post))
    #         end
    #       end
    #     end
    #   end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
  end # content
end
