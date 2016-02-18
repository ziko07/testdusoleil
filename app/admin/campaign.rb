ActiveAdmin.register Campaign do
  # filter :"creator" , :as => :select, :collection => Campaign::CREATORS.collect {|o|[o,o]}
  # filter :"tracker" , :as => :select, :collection => Tracker.all.collect {|o| [o.domain, o.id]}
  # filter :"traffic_type" , :as => :select, :collection => Campaign::TRAFFIC_TYPE_VALUES.collect {|o|[o,o]}
  # filter :"user" , :as => :select, :collection => User.all.collect {|o| [o.email, o.id]}
  actions :all, :except => [:show, :edit]
  index do
    campaigns.sort!{|a,b| b.hit_counts_total <=> a.hit_counts_total}
    column :status
    column 'Latest Hit' do |c|
      c.hits.last ? formatted(c.hits.last.created_at): "None"
    end
    column 'Hit' do |c|
      c.hit_counts_total
    end
    column :creator
    column :safe_lp
    column :real_lp
    column :tracker
    column '' do |c|
       span link_to 'Edit', campaign_path(c)
       span link_to 'Stat', stats_campaign_path(c)
    end
  end

  controller do
    # Custom new method
    def new
      redirect_to new_campaign_path
    end
  end

  # collection_action :create do
  #   redirect_to new_campaign_path
  # end

end
