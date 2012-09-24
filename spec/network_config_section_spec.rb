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
    net_config.parent_network = VCloud::ParentNetworkReference.new({})
    net_config.fence_mode = "bridged"
    
    net_section = VCloud::NetworkConfigSection.new
    net_section.network_configurations << net_config
    
    # TODO: Reserialize XML we receive and compare to expected value, not overall XML doc
  end
  
end