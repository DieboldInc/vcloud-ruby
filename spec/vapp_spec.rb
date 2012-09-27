require 'spec_helper'

include WebMock::API

describe VCloud::VApp do
  
  before(:each) do
    @vapp = VCloud::VApp.from_xml(fixture_file('vapp.xml'))
  end
  
  describe 'parses xml #from_xml' do 
    it 'should have correct values' do
      @vapp.name.should == "Linux FTP server"
      @vapp.id.should == 'urn:vcloud:vapp:aaa-bbb-ccc-ddd-eee-fff'
      @vapp.type.should == 'application/vnd.vmware.vcloud.vApp+xml'
      @vapp.href.should == "https://some.vcloud.com/api/vApp/vapp-aaa-bbb-ccc-ddd-eee-fff"
    end
    
    it 'should parse links' do
      @vapp.links.should_not be_nil
      @vapp.links.should have(5).items
      
      @vapp.links.first.type.should == 'application/vnd.vmware.vcloud.vAppNetwork+xml'
      @vapp.links.first.name.should == 'Dev VLAN'
      @vapp.links.first.href.should == 'https://some.vcloud.com/api/network/aaa-bbb-ccc-ddd-eee-fff'
    end
    
    it 'should parse tasks' do
      @vapp.tasks.should_not be_nil
      @vapp.tasks.should have(1).items
      @vapp.tasks.first.status.should == 'running'
      @vapp.tasks.first.operation_name.should == 'vdcInstantiateVapp'
      @vapp.tasks.first.operation.should == 'Creating Virtual Application Linux FTP server(aaa-bbb-ccc-ddd-eee-fff)'
      @vapp.tasks.first.expiry_time.should == '2012-12-19T10:40:08.286-05:00'
      @vapp.tasks.first.name.should == 'task'
      @vapp.tasks.first.id.should == 'urn:vcloud:task:aaa-bbb-ccc-ddd-eee-fff'
      @vapp.tasks.first.href.should == 'https://some.vcloud.com/api/task/aaa-bbb-ccc-ddd-eee-fff'

      @vapp.tasks.first.links.should have(1).item
      @vapp.tasks.first.links.first.rel.should == 'task:cancel'
      @vapp.tasks.first.links.first.href.should == 'https://some.vcloud.com/api/task/aaa-bbb-ccc-ddd-eee-fff/action/cancel'
    end
  end
  
  it "retrieves a VApp" do
    stub_request(:get, 'https://some.vcloud.com/api/vApp/vapp-aaa-bbb-ccc-ddd-eee-fff').
      with(:headers => {'Accept'=>'application/vnd.vmware.vcloud.vApp+xml;version=1.5', 'X-Vcloud-Authorization'=>'abc123xyz'}).
      to_return(:status => 200, :body => fixture_file('vapp.xml'), :headers => {})
             
    vapp = VCloud::VApp.from_reference(stub(:href => 'https://some.vcloud.com/api/vApp/vapp-aaa-bbb-ccc-ddd-eee-fff'), @session)
    
    vapp.name.should == "Linux FTP server"
    vapp.href.should == 'https://some.vcloud.com/api/vApp/vapp-aaa-bbb-ccc-ddd-eee-fff'
    vapp.links.should have(5).items
  end
  
end