require 'spec_helper'

include WebMock::API

describe VCloud::Client do
  before(:all) do
    @test_session_url = 'https://some.vcloud.com/api/sessions' 
    @test_api_version = '1.5'
    
    @session = VCloud::Client.new('https://some.vcloud.com/api/', '1.5')        
  end
  
  before(:each) do
    # Creates a Session Stub    
    stub_request(:post, "https://someuser%40someorg:password@some.vcloud.com/api/sessions").
             with(:headers => {'Accept'=>'application/*+xml;version=1.5', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'}).
             to_return(:status => 200, :body => VCloud::Test::Data::SESSION_XML, :headers => {:x_vcloud_authorization => "abc123xyz"})
             
    
    # Org List stub
    stub_request(:get, "https://some.vcloud.com/api/org/").
             with(:headers => {'Accept'=>'application/vnd.vmware.vcloud.orgList+xml;version=1.5', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby', 'X-Vcloud-Authorization'=>'abc123xyz'}).
             to_return(:status => 200, :body => VCloud::Test::Data::ORG_LIST_XML, :headers => {})
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
  end
  
  it "retrieves a list of orginizations" do
    org_refs = @session.get_org_refs
   
    org_refs.should have(1).items
    org_refs.first.name.should == "someorg"
    org_refs.first.href.should == "https://some.vcloud.com/api/org/aaa-bbb-ccc-ddd-eee-fff"
  end  
end