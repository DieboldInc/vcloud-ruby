require 'spec_helper'

include WebMock::API

describe VCloud::NetworkConfigSection do
  
  before(:each) do
    
  end
  
  it "creates a new NetworkConfigSection" do
    net_section = VCloud::NetworkConfigSection.new
    net_section.network_configurations.should have(0).items
  end
  
  it "adds a VAppNetworkConfig" do
    net_config = VCloud::VAppNetworkConfig.new
    net_config.network_name = "TestVappNetworkConfigNetwork"
    net_config.parent_network_ref = VCloud::NetworkReference.new({})
    net_config.fence_mode = "bridged"
    
    net_section = VCloud::NetworkConfigSection.new
    net_section.network_configurations << net_config
    
    net_section.network_configurations.should have(1).item
    net_section.network_configurations.first.network_name.should == "TestVappNetworkConfigNetwork"
    net_section.network_configurations.first.fence_mode.should == "bridged"
  end
  
  it "seralizes to XML" do
    # net_config = VCloud::VAppNetworkConfig.new
    net_config = VCloud::NetworkConfiguration.new
    net_config.network_name = "TestVappNetworkConfigNetwork"
    # TODO: Actually make a parent network
    net_config.parent_network = VCloud::ParentNetworkReference.new({})
    net_config.fence_mode = "bridged"
    
    net_section = VCloud::NetworkConfigSection.new
    net_section.network_configurations << net_config
    
    xml = net_section.to_xml
    doc = Nokogiri::XML(xml)
    
    doc.at_xpath('/xmlns:NetworkConfigSection/xmlns:NetworkConfiguration')['networkName'].should == "TestVappNetworkConfigNetwork"
    doc.at_xpath('/xmlns:NetworkConfigSection/xmlns:NetworkConfiguration/xmlns:FenceMode').text.should == "bridged"
  end
  
end