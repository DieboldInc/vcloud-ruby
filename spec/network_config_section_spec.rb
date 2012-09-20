require 'spec_helper'

include WebMock::API

describe VCloud::NetworkConfigSection do
  
  before(:each) do
    
  end
  
  it "creates a new NetworkConfigSection" do
    net_section = VCloud::NetworkConfigSection.new

    net_section.configurations.should have(0).items
  end
  
  it "adds a VAppNetworkConfig" do
    net_config = VCloud::VAppNetworkConfig.new
    net_config.network_name = "TestVappNetworkConfigNetwork"
    net_config.parent_network_ref = VCloud::Reference.new({})
    net_config.fence_mode = "bridged"
    
    net_section = VCloud::NetworkConfigSection.new
    net_section.configurations << net_config
    
    net_section.configurations.should have(1).item
    net_section.configurations.first.network_name.should == "TestVappNetworkConfigNetwork"
    net_section.configurations.first.fence_mode.should == "bridged"
  end
  
  it "seralizes to XML" do
    net_config = VCloud::VAppNetworkConfig.new
    net_config.network_name = "TestVappNetworkConfigNetwork"
    net_config.parent_network_ref = VCloud::Reference.new({})
    net_config.fence_mode = "bridged"
    
    net_section = VCloud::NetworkConfigSection.new
    net_section.configurations << net_config
    
    xml = ""
    net_section.to_xml.split.each do |line|
      xml += line.strip
    end
    
    compare_xml = ""
    VCloud::Test::Data::NETWORK_CONFIG_SECTION_XML.split.each do |line|
      compare_xml += line.strip
    end
    
    xml.should == compare_xml
  end
  
end