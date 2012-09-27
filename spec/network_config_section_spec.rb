require 'spec_helper'

include WebMock::API

describe VCloud::NetworkConfigSection do

  it 'should #initialize' do
    net_section = VCloud::NetworkConfigSection.new
    net_section.network_configs.should have(0).items
    net_section.info.should == 'Configuration parameters for logical networks'
  end
  
  describe 'when parsing #from_xml' do
    before(:each) do
      @net_section = VCloud::NetworkConfigSection.from_xml(fixture_file('network_config_section.xml'))
    end
    
   it 'should have correct values' do
     @net_section.href.should == 'https://vcloud.example.dev/api/vAppTemplate/vappTemplate-1/networkConfigSection/'
     @net_section.type.should == 'application/vnd.vmware.vcloud.networkConfigSection+xml'
     @net_section.info.should == 'The configuration parameters for logical networks'
     @net_section.network_configs.should have(1).items
   end
 end  

  it "should serialize #to_xml" do      
    net_section = VCloud::NetworkConfigSection.new
    net_section.href = 'http://some.href.com'    
    net_section.type = 'some type'
    net_section.info = 'info text'
    net_section.network_configs << "net section text"
    
    xml = net_section.to_xml
    doc = Nokogiri::XML(xml)

    doc.xpath('/xmlns:NetworkConfigSection/@href').text.should == "http://some.href.com"
    doc.xpath('/xmlns:NetworkConfigSection/@type').text.should == "some type"
    doc.xpath('/xmlns:NetworkConfigSection/ovf:Info').text.should == "info text"
    doc.xpath('/xmlns:NetworkConfigSection/xmlns:NetworkConfig').text.should == "net section text"
  end   
  
end