require 'spec_helper'

describe VCloud::NetworkConfig do
  
  describe 'when parsing #from_xml' do
    before(:each) do
      @config = VCloud::NetworkConfig.from_xml(fixture_file('network_config.xml'))
    end
    
    it 'should have correct values' do
       @config.network_name.should == 'TestVappNetworkConfigNetwork'
       @config.parent_network_reference.href.should == 'http://parentnetwork.com'
       @config.fence_mode.should == 'bridged'
    end    
  end
  
  it 'should serialize #to_xml' do
    config = VCloud::NetworkConfig.new
    config.network_name = 'netname'
    config.parent_network_reference = VCloud::Reference.new :href => 'http://parentnetwork.com'
    config.fence_mode = 'isolated'
    
    xml = config.to_xml
    doc = Nokogiri::XML(xml)

    doc.xpath('/NetworkConfig/@networkName').text.should == 'netname'
    doc.xpath('/NetworkConfig/Configuration/ParentNetwork/@href').text.should == 'http://parentnetwork.com'
    doc.xpath('/NetworkConfig/Configuration/FenceMode').text.should == 'isolated'
  end
  
end