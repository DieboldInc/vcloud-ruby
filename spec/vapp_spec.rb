require 'spec_helper'

include WebMock::API

describe VCloud::VApp do
  
  before(:each) do
    stub_request(:get, "https://some.vcloud.com/api/vApp/vapp-aaa-bbb-ccc-ddd-eee-fff").
             with(:headers => {'Accept'=>'application/vnd.vmware.vcloud.vApp+xml;version=1.5', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby', 'X-Vcloud-Authorization'=>'abc123xyz'}).
             to_return(:status => 200, :body => VCloud::Test::Data::VAPP_XML, :headers => {})
  end
  
  it "retrieves a VApp" do
    vapp_href = "https://some.vcloud.com/api/vApp/vapp-aaa-bbb-ccc-ddd-eee-fff"
    vapp = VCloud::VApp.from_reference(VCloud::Reference.new({:href => vapp_href}))

    vapp.name.should == "Linux FTP server"
    vapp.href.should == vapp_href
    vapp.links.should have(6).items
  end
  
  it "parses tasks" do
    
  end
  
end