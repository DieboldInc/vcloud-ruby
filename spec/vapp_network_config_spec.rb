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
    
    xml = net_config.to_xml
    doc = Nokogiri::XML(xml)
    
    doc.at_xpath('/xmlns:NetworkConfig')['networkName'].should == "TestVappNetworkConfigNetwork"
    doc.at_xpath('/xmlns:NetworkConfig/xmlns:Configuration/xmlns:FenceMode').text.should == "bridged"
  end
  
end