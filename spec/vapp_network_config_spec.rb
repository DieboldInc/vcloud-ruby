require 'spec_helper'

include WebMock::API

describe VCloud::VAppNetworkConfig do
  
  before(:each) do
    
  end
  
  it "creates a new VAppNetworkConfig" do
    net_config = VCloud::VAppNetworkConfig.new
    
    net_config.should_not == nil
    net_config.network_name.should == nil
    net_config.parent_network_ref.should == nil
    net_config.fence_mode.should == nil
  end
  
  it "seralizes to XML" do
    net_config = VCloud::VAppNetworkConfig.new
    net_config.network_name = "TestVappNetworkConfigNetwork"
    net_config.parent_network_ref = VCloud::NetworkReference.new({})
    net_config.fence_mode = "bridged"
    
    # TODO: Reserialize XML we receive and compare to expected value, not overall XML doc
  end
  
end