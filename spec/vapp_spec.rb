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
    vapp = VCloud::VApp.from_reference(VCloud::VAppReference.new({:href => vapp_href}))

    vapp.name.should == "Linux FTP server"
    vapp.href.should == vapp_href
    vapp.links.should have(5).items
  end
  
  it "can be parsed from XML" do
    vapp = VCloud::VApp.from_xml(VCloud::Test::Data::VAPP_XML)
    
    vapp.name.should == "Linux FTP server"
    vapp.href.should == "https://some.vcloud.com/api/vApp/vapp-aaa-bbb-ccc-ddd-eee-fff"
    vapp.links.should have(5).items
    
    vapp.tasks.should_not == nil
    vapp.tasks.should have(1).items
    vapp.tasks.first.status.should == 'running'
    vapp.tasks.first.operation_name.should == 'vdcInstantiateVapp'
    vapp.tasks.first.operation.should == 'Creating Virtual Application Linux FTP server(aaa-bbb-ccc-ddd-eee-fff)'
    vapp.tasks.first.expiry_time.should == '2012-12-19T10:40:08.286-05:00'
    vapp.tasks.first.name.should == 'task'
    vapp.tasks.first.id.should == 'urn:vcloud:task:aaa-bbb-ccc-ddd-eee-fff'
    vapp.tasks.first.href.should == 'https://some.vcloud.com/api/task/aaa-bbb-ccc-ddd-eee-fff'
    
    vapp.tasks.first.links.should have(1).item
    vapp.tasks.first.links.first.rel.should == 'task:cancel'
    vapp.tasks.first.links.first.href.should == 'https://some.vcloud.com/api/task/aaa-bbb-ccc-ddd-eee-fff/action/cancel'
  end
  
  it "parses tasks" do
    vapp_href = "https://some.vcloud.com/api/vApp/vapp-aaa-bbb-ccc-ddd-eee-fff"
    vapp = VCloud::VApp.from_reference(VCloud::VAppReference.new({:href => vapp_href}))

    vapp.tasks.should_not == nil
    vapp.tasks.should have(1).items
    vapp.tasks.first.status.should == 'running'
    vapp.tasks.first.operation_name.should == 'vdcInstantiateVapp'
    vapp.tasks.first.operation.should == 'Creating Virtual Application Linux FTP server(aaa-bbb-ccc-ddd-eee-fff)'
    vapp.tasks.first.expiry_time.should == '2012-12-19T10:40:08.286-05:00'
    vapp.tasks.first.name.should == 'task'
    vapp.tasks.first.id.should == 'urn:vcloud:task:aaa-bbb-ccc-ddd-eee-fff'
    vapp.tasks.first.href.should == 'https://some.vcloud.com/api/task/aaa-bbb-ccc-ddd-eee-fff'
    
    vapp.tasks.first.links.should have(1).item
    vapp.tasks.first.links.first.rel.should == 'task:cancel'
    vapp.tasks.first.links.first.href.should == 'https://some.vcloud.com/api/task/aaa-bbb-ccc-ddd-eee-fff/action/cancel'
  end
  
end