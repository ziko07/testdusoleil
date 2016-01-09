require 'spec_helper'

describe Campaign do
  before do
    Rails.cache.clear
  end

  it "rekeys correctly" do
    Tracker.create(:domain => "http://www3.example.com", :ip => '192.0.2.1')
    c = Campaign.new
    c.creator = "david"
    c.tracker = "http://www3.example.com"
    c.safe_lp = "http://www.example.com?foo=bar"
    c.real_lp = "http://www2.example.com?fred=wilma"
    c.rekey_from_1 = "kw1"
    c.rekey_to_1 = "kw2"
    c.save
    c.should be_valid
    c.rekeyed_lp("/?h=oiejfw&kw1=blah", :safe_lp).should== "http://www.example.com?foo=bar&kw2=blah"
  end

  it "should reject an incorrect tracker" do
    Tracker.create(:domain => "http://www3.example.com", :ip => '192.0.2.1')
    c = Campaign.new(:tracker => "foo")
    c.should_not be_valid
    c.errors.should include(:tracker)
  end

  it "notices recent hits" do
    Tracker.create(:domain => "http://www3.example.com", :ip => '192.0.2.1')
    c = Campaign.new
    c.creator = "david"
    c.status = "on"
    c.tracker = "http://www3.example.com"
    c.safe_lp = "http://www.example.com?foo=bar"
    c.real_lp = "http://www2.example.com?fred=wilma"
    c.save
    c.should be_valid
    request = mock_model('Request', :ip => "5.5.5.5", :user_agent => "", 
      :referrer => "", :fullpath => "", :headers => {})
    Hit.select_lp_from_request(request, c).should== :real_lp
    Hit.count.should== 1
    Hit.select_lp_from_request(request, c).should== :safe_lp
    Hit.count.should== 1
  end
  
  context "testing referring domain..." do
    
    before :each do
      Tracker.create(:domain => "http://www3.example.com", :ip => '192.0.2.1')
      @c = Campaign.new
      @c.creator = "david"
      @c.status = "on"
      @c.tracker = "http://www3.example.com"
      @c.safe_lp = "http://www.example.com?foo=bar"
      @c.real_lp = "http://www2.example.com?fred=wilma"
      @c.save
      @c.should be_valid
    end
    
    it "doesnt barf on malformed URI" do
      request = mock_model('Request', :ip => "5.5.5.5", :user_agent => "", 
       :referrer => ":", :fullpath => "", :headers => {})
      Hit.select_lp_from_request(request, @c).should== :real_lp
    end
    
    context "when all filters are inactive..." do
    
      it "then any hit should get :real_lp" do
        request = mock_model('Request', :ip => "5.5.5.5", :user_agent => "", 
          :referrer => "http://www.randomdomain.com/testpage.html", :fullpath => "", :headers => {})
        Hit.select_lp_from_request(request, @c).should== :real_lp
        Hit.count.should== 1
      end
      
    end
    
    context "when at least one filter is active..." do
    
      it "when it matches one entered into filter_domain_other then it should get :real_lp" do
        @c.filter_domain_other = "testdomain.com, testdomain2.com"
        @c.save
        @c.should be_valid
        @c.filter_domain_other.length.should > 0
        request = mock_model('Request', :ip => "5.5.5.5", :user_agent => "", 
          :referrer => "http://www.testdomain.com/testpage.html", :fullpath => "", :headers => {})
        Hit.select_lp_from_request(request, @c).should== :real_lp
        Hit.count.should== 1
      end

      it "when it does not match any entered into filter_domain_other then it should get :safe_lp" do
        @c.filter_domain_other = "testdomain.com, testdomain2.com"
        @c.save
        @c.should be_valid
        @c.filter_domain_other.length.should > 0
        request = mock_model('Request', :ip => "5.5.5.5", :user_agent => "", 
         :referrer => "http://www.testdomain3.com/testpage.html", :fullpath => "", :headers => {})
        Hit.select_lp_from_request(request, @c).should== :safe_lp
        Hit.count.should== 1
      end

      it "when it comes from facebook.com and filter_domain_facebook == true it should get :real_lp" do
         @c.filter_domain_facebook = true
         @c.save
         @c.should be_valid
         @c.filter_domain_facebook.should be_true
         request = mock_model('Request', :ip => "5.5.5.5", :user_agent => "", 
          :referrer => "http://www.facebook.com/index.html", :fullpath => "", :headers => {})
         Hit.select_lp_from_request(request, @c).should== :real_lp
         Hit.count.should== 1
       end

       it "when it does not come from facebook.com and filter_domain_facebook == true it should get :safe_lp" do
         @c.filter_domain_facebook = true
         @c.save
         @c.should be_valid
         @c.filter_domain_facebook.should be_true
         request = mock_model('Request', :ip => "5.5.5.5", :user_agent => "", 
          :referrer => "http://www.google.com/index.html", :fullpath => "", :headers => {})
         Hit.select_lp_from_request(request, @c).should== :safe_lp
         Hit.count.should== 1
       end
    
      it "when it comes from google.com and filter_domain_google == true it should get :real_lp" do
        @c.filter_domain_google = true
        @c.save
        @c.should be_valid
        @c.filter_domain_google.should be_true
        request = mock_model('Request', :ip => "5.5.5.5", :user_agent => "", 
         :referrer => "http://www.google.com/index.html", :fullpath => "", :headers => {})
        Hit.select_lp_from_request(request, @c).should== :real_lp
        Hit.count.should== 1
      end
    
      it "when it does not come from google.com and filter_domain_google == true it should get :safe_lp" do
        @c.filter_domain_google = true
        @c.save
        @c.should be_valid
        @c.filter_domain_google.should be_true
        request = mock_model('Request', :ip => "5.5.5.5", :user_agent => "", 
         :referrer => "http://www.facebook.com/index.html", :fullpath => "", :headers => {})
        Hit.select_lp_from_request(request, @c).should== :safe_lp
        Hit.count.should== 1
      end

      it "when it comes from msn.com and filter_domain_msn == true it should get :real_lp" do
        @c.filter_domain_msn = true
        @c.save
        @c.should be_valid
        @c.filter_domain_msn.should be_true
        request = mock_model('Request', :ip => "5.5.5.5", :user_agent => "", 
         :referrer => "http://www.msn.com/index.html", :fullpath => "", :headers => {})
        Hit.select_lp_from_request(request, @c).should== :real_lp
        Hit.count.should== 1
      end

      it "when it does not come from msn.com and filter_domain_msn == true it should get :safe_lp" do
        @c.filter_domain_msn = true
        @c.save
        @c.should be_valid
        @c.filter_domain_msn.should be_true
        request = mock_model('Request', :ip => "5.5.5.5", :user_agent => "", 
         :referrer => "http://www.gmail.com/index.html", :fullpath => "", :headers => {})
        Hit.select_lp_from_request(request, @c).should== :safe_lp
        Hit.count.should== 1
      end
    end

  end

end
