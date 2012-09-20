require 'spec_helper'

#net_config = VCloud::VAppNetworkConfig.new
#net_config.network_name = network_ref.name
#net_config.parent_network_ref = network_ref
#net_config.fence_mode = 'bridged'
#:network_name, :parent_network_ref, :fence_mode

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
    net_config.parent_network_ref = VCloud::Reference.new({})
    net_config.fence_mode = "bridged"
    
    xml = ""
    net_config.to_xml.split.each do |line|
      xml += line.strip
    end
    
    compare_xml = ""
    VCloud::Test::Data::NETWORK_CONFIG_XML.split.each do |line|
      compare_xml += line.strip
    end
    
    xml.should == compare_xml
  end
  
end