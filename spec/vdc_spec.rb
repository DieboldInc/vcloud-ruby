require 'spec_helper'

include WebMock::API

describe VCloud::Vdc do
  
  before(:each) do
    stub_request(:get, "https://some.vcloud.com/api/vdc/aaa-bbb-ccc-ddd-eee-fff").
             with(:headers => {'Accept'=>'application/vnd.vmware.vcloud.vdc+xml;version=1.5', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby', 'X-Vcloud-Authorization'=>'abc123xyz'}).
             to_return(:status => 200, :body => VCloud::Test::Data::VDC_XML, :headers => {})
  end
  
  it "retrieves a VDC" do
    vdc_href = "https://some.vcloud.com/api/vdc/aaa-bbb-ccc-ddd-eee-fff"
    vdc = VCloud::Vdc.from_reference(VCloud::Reference.new({:href => vdc_href}), @session)
    
    WebMock.should have_requested(:get, vdc_href).
      with(:headers => {'Accept'=>'application/vnd.vmware.vcloud.vdc+xml;version=1.5', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby', 'X-Vcloud-Authorization'=>'abc123xyz'})
    
    vdc.name.should == "TestVDC"
    vdc.href.should == "https://some.vcloud.com/api/vdc/aaa-bbb-ccc-ddd-eee-fff"
    vdc.links.should have(10).items
  end
  
  it "pareses a network references" do
    vdc_href = "https://some.vcloud.com/api/vdc/aaa-bbb-ccc-ddd-eee-fff"
    vdc = VCloud::Vdc.from_reference(VCloud::Reference.new({:href => vdc_href}), @session)
    
    WebMock.should have_requested(:get, vdc_href).
      with(:headers => {'Accept'=>'application/vnd.vmware.vcloud.vdc+xml;version=1.5', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby', 'X-Vcloud-Authorization'=>'abc123xyz'})
    
    vdc.network_references.should have(1).item
    vdc.network_references.first.name.should == "Dev VLAN"
    vdc.network_references.first.href.should == "https://some.vcloud.com/api/network/aaa-bbb-ccc-ddd-eee-fff"
  end
  
end
