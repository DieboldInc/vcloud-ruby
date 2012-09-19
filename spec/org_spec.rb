require 'spec_helper'

include WebMock::API

describe VCloud::Org do
  
  before(:all) do
    
  end
  
  it "retrieves an orginization" do    
    stub_request(:get, "https://some.vcloud.com/api/org/").
             with(:headers => {'Accept'=>'application/vnd.vmware.vcloud.orgList+xml;version=1.5', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby', 'X-Vcloud-Authorization'=>'abc123xyz'}).
             to_return(:status => 200, :body => VCloud::Test::Data::ORG_LIST_XML, :headers => {})
    stub_request(:get, "https://some.vcloud.com/api/org/aaa-bbb-ccc-ddd-eee-fff").
            with(:headers => {'Accept'=>'application/vnd.vmware.vcloud.org+xml;version=1.5', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby', 'X-Vcloud-Authorization'=>'abc123xyz'}).
            to_return(:status => 200, :body => VCloud::Test::Data::ORG_XML, :headers => {})
    
    org = VCloud::Org.from_reference(VCloud::Reference.new({:href => "https://some.vcloud.com/api/org/aaa-bbb-ccc-ddd-eee-fff"}))
    
    org.vdc_links.should have(1).items
    org.catalog_links.should have(1).items
    org.org_network_links.should have(1).items
  end
  
end