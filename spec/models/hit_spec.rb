require 'spec_helper'

describe Hit do
  it "filters for mobile user agents" do
    subject.user_agent = "foo Mobile foo"
    campaign = Campaign.new
    subject.campaign = campaign
    campaign.mobile_filter_mobile = true
    subject.mobile_user_agent_allowed?.should == false
    subject.user_agent = "foo Android foo"
    subject.mobile_user_agent_allowed?.should == true
    subject.user_agent = "foo iPod foo"
    subject.mobile_user_agent_allowed?.should == true
    campaign.mobile_filter_allow = true
    subject.mobile_user_agent_allowed?.should == false
    campaign.mobile_filter_ios = true
    subject.mobile_user_agent_allowed?.should == true
  end
end

