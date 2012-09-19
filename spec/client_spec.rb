require 'spec_helper'

include WebMock::API

describe VCloud::Client do
  before(:all) do
    @test_session_url = 'https://some.vcloud.com/api/sessions' 
    @test_api_version = '1.5'
    
    @session = VCloud::Client.new('https://some.vcloud.com/api/', '1.5')
    
    
    # Creates a Session Stub
    session_xml  = %q{<?xml version="1.0" encoding="UTF-8"?>
    <Session xmlns="http://www.vmware.com/vcloud/v1.5" user="test" org="someorg" type="application/vnd.vmware.vcloud.session+xml" href="https://some.vcloud.com/api/session/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.vmware.com/vcloud/v1.5 http://10.9.225.10/api/v1.5/schema/master.xsd">
        <Link rel="down" type="application/vnd.vmware.vcloud.orgList+xml" href="https://some.vcloud.com/api/org/"/>
        <Link rel="down" type="application/vnd.vmware.admin.vcloud+xml" href="https://some.vcloud.com/api/admin/"/>
        <Link rel="down" type="application/vnd.vmware.vcloud.query.queryList+xml" href="https://some.vcloud.com/api/query"/>
        <Link rel="entityResolver" type="application/vnd.vmware.vcloud.entity+xml" href="https://some.vcloud.com/api/entity/"/>
    </Session>}
    
    stub_request(:post, "https://someuser%40someorg:password@some.vcloud.com/api/sessions").
             with(:headers => {'Accept'=>'application/*+xml;version=1.5', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'}).
             to_return(:status => 200, :body => session_xml, :headers => {:x_vcloud_authorization => "abc123xyz"})
                
  end
  
  it "creates a session" do             
    @session.login('someuser@someorg', 'password')
    VCloud::Session.set_session(@session)
    
    @session.url.should == "https://some.vcloud.com/api/"
    @session.api_version.should == "1.5"
    @session.user.should == "someuser"
    @session.token.should_not == nil
    @session.token[:x_vcloud_authorization].should == "abc123xyz"
    @session.links.should have(4).items
    
    puts @session.inspect
  end
  
  it "retrieves a list of orginizations" do
    org_list_xml = %q{<?xml version="1.0" encoding="UTF-8"?>
    <OrgList xmlns="http://www.vmware.com/vcloud/v1.5" type="application/vnd.vmware.vcloud.orgList+xml" href="https://some.vcloud.com/api/org/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.vmware.com/vcloud/v1.5 http://127.0.0.1/api/v1.5/schema/master.xsd">
        <Org type="application/vnd.vmware.vcloud.org+xml" name="someorg" href="https://some.vcloud.com/api/org/aaa-bbb-ccc-ddd-eee-fff"/>
    </OrgList>}

    stub_request(:get, "https://some.vcloud.com/api/org/").
             with(:headers => {'Accept'=>'application/vnd.vmware.vcloud.orgList+xml;version=1.5', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby', 'X-Vcloud-Authorization'=>'abc123xyz'}).
             to_return(:status => 200, :body => org_list_xml, :headers => {})
    
    org_refs = @session.get_org_refs
   
    org_refs.should have(1).items
    org_refs.first.name.should == "someorg"
    
  end
end