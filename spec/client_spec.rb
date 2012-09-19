require 'spec_helper'

include WebMock::API

describe VCloud::Client do
  before(:each) do
        
  end
  
  it "returns a session" do
    test_session_url = 'https://some.vcloud.com/api/sessions' 
    test_api_version = '1.5'
    session_xml  = %q{<?xml version="1.0" encoding="UTF-8"?>
    <Session xmlns="http://www.vmware.com/vcloud/v1.5" user="test" org="someorg" type="application/vnd.vmware.vcloud.session+xml" href="https://some.vcloud.com/api/session/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.vmware.com/vcloud/v1.5 http://10.9.225.10/api/v1.5/schema/master.xsd">
        <Link rel="down" type="application/vnd.vmware.vcloud.orgList+xml" href="https://some.vcloud.com/api/org/"/>
        <Link rel="down" type="application/vnd.vmware.admin.vcloud+xml" href="https://some.vcloud.com/api/admin/"/>
        <Link rel="down" type="application/vnd.vmware.vcloud.query.queryList+xml" href="https://some.vcloud.com/api/query"/>
        <Link rel="entityResolver" type="application/vnd.vmware.vcloud.entity+xml" href="https://some.vcloud.com/api/entity/"/>
    </Session>}
    
    stub_request(:post, "https://test%40someorg:password@some.vcloud.com/api/sessions").
             with(:headers => {'Accept'=>'application/*+xml;version=#{@api_version}', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'}).
             to_return(:status => 200, :body => session_xml, :headers => {:x_vcloud_authorization => "abc123xyz"})
    
    session = VCloud::Client.new('https://some.vcloud.com/api/', '1.5')
    session.login('test@someorg', 'password')
    
    WebMock.should have_requested(:post, "https://test%40someorg:password@some.vcloud.com/api/sessions")
  end
end