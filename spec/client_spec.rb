require 'spec_helper'

include WebMock::API

describe VCloud::Client do
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
    test_session = VCloud::Client.new(VCloud::Test::Constants::API_URL, VCloud::Test::Constants::API_VERSION)             
    test_session.login(VCloud::Test::Constants::USERNAME_WITH_ORG, VCloud::Test::Constants::PASSWORD)
    VCloud::Session.set_session(test_session)
    
    test_session.url.should == VCloud::Test::Constants::API_URL
    test_session.api_version.should == VCloud::Test::Constants::API_VERSION
    test_session.user.should == VCloud::Test::Constants::USERNAME
    test_session.token.should_not == nil
    test_session.token[:x_vcloud_authorization].should == "abc123xyz"
    test_session.links.should have(4).items
  end
  
  it "retrieves a list of orginizations" do
    org_refs = @session.get_org_refs
   
    org_refs.should have(1).items
    org_refs.first.name.should == "someorg"
    org_refs.first.href.should == "https://some.vcloud.com/api/org/aaa-bbb-ccc-ddd-eee-fff"
  end  
end