require 'spec_helper'

include WebMock::API

describe VCloud::Client do
  
  it "should login" do
    stub_request(:post, "https://someuser%40someorg:password@some.vcloud.com/api/sessions").
             with(:headers => {'Accept'=>'application/*+xml;version=1.5'}).
             to_return(:status => 200, :body => fixture_file('session.xml'), :headers => {:x_vcloud_authorization => "abc123xyz"})
        
    test_session = VCloud::Client.new('https://some.vcloud.com/api/', '1.5')             
    test_session.login('someuser@someorg', 'password')
                               
    test_session.url.should == 'https://some.vcloud.com/api/'
    test_session.api_version.should == '1.5'
    test_session.user.should == 'someuser'
    test_session.org.should == 'someorg'
    test_session.type.should == 'application/vnd.vmware.vcloud.session+xml'
    test_session.href.should == 'https://some.vcloud.com/api/session/'
    test_session.token.should_not be_nil
    test_session.token[:x_vcloud_authorization].should == "abc123xyz"
    test_session.links.should have(4).items
    test_session.logged_in?.should == true
  end

  it "should #get_org_refs" do
    stub_request(:get, "https://some.vcloud.com/api/org/").
      with(:headers => {'Accept'=>'application/vnd.vmware.vcloud.orgList+xml;version=1.5', 'X-Vcloud-Authorization'=>'abc123xyz'}).
      to_return(:status => 200, :body => fixture_file('org_list.xml'))

    org_refs = @session.get_org_refs
   
    WebMock.should have_requested(:get, "https://some.vcloud.com/api/org/").
      with(:headers => {'Accept'=>'application/vnd.vmware.vcloud.orgList+xml;version=1.5', 'X-Vcloud-Authorization'=>'abc123xyz'})
   
    org_refs.should have(1).items
    org_refs.first.name.should == "someorg"
    org_refs.first.href.should == "https://some.vcloud.com/api/org/aaa-bbb-ccc-ddd-eee-fff"    
  end
  
  it "should #get_org_refs_by_name" do 
    stub_request(:get, "https://some.vcloud.com/api/org/").
      with(:headers => {'Accept'=>'application/vnd.vmware.vcloud.orgList+xml;version=1.5', 'X-Vcloud-Authorization'=>'abc123xyz'}).
      to_return(:status => 200, :body => fixture_file('org_list.xml'))
    
    hash = @session.get_org_refs_by_name
    
    hash.should have(1).items
    hash['someorg'].should_not be_nil   
  end
  
  it "should #get_org_from_name if name exists" do 
    stub_request(:get, "https://some.vcloud.com/api/org/").
      with(:headers => {'Accept'=>'application/vnd.vmware.vcloud.orgList+xml;version=1.5', 'X-Vcloud-Authorization'=>'abc123xyz'}).
      to_return(:status => 200, :body => fixture_file('org_list.xml'))
                                                                                          
    VCloud::Org.should_receive(:from_reference).and_return("not nil")

    org = @session.get_org_from_name('someorg')    

    org.should_not be_nil
  end                         
  
  it "should return nil #get_org_from_name if name does not exist" do
    stub_request(:get, "https://some.vcloud.com/api/org/").
      with(:headers => {'Accept'=>'application/vnd.vmware.vcloud.orgList+xml;version=1.5', 'X-Vcloud-Authorization'=>'abc123xyz'}).
      to_return(:status => 200, :body => fixture_file('org_list.xml'))
      
    VCloud::Org.should_not_receive(:from_reference)

    org = @session.get_org_from_name('no_such_org')    

    org.should be_nil   
  end
  
  it "should #logout and destroy the session" do
    stub_request(:delete, "https://some.vcloud.com/api/session").
             with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'X-Vcloud-Authorization'=>'abc123xyz'}).
             to_return(:status => 204, :body => "", :headers => {})
    
    @session.logout
    
    @session.logged_in.should == false
    @session.token.should == nil
  end
end