require 'spec_helper'

include WebMock::API

describe VCloud::Org do
  
  before(:each) do
    
    # Org List stub
    stub_request(:get, "https://some.vcloud.com/api/org/").
             with(:headers => {'Accept'=>'application/vnd.vmware.vcloud.orgList+xml;version=1.5', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby', 'X-Vcloud-Authorization'=>'abc123xyz'}).
             to_return(:status => 200, :body => VCloud::Test::Data::ORG_LIST_XML, :headers => {})
             
    # Org stub
    stub_request(:get, "https://some.vcloud.com/api/org/aaa-bbb-ccc-ddd-eee-fff").
            with(:headers => {'Accept'=>'application/vnd.vmware.vcloud.org+xml;version=1.5', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby', 'X-Vcloud-Authorization'=>'abc123xyz'}).
            to_return(:status => 200, :body => VCloud::Test::Data::ORG_XML, :headers => {})
  end
  
  it "retrieves an orginization" do    
    org_href = "https://some.vcloud.com/api/org/aaa-bbb-ccc-ddd-eee-fff"
    org = VCloud::Org.from_reference(VCloud::Reference.new({:href => org_href}), @session)
    
    WebMock.should have_requested(:get, org_href).
      with(:headers => {'Accept'=>'application/vnd.vmware.vcloud.org+xml;version=1.5', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby', 'X-Vcloud-Authorization'=>'abc123xyz'})
    
    org.vdc_links.should have(1).items
    org.catalog_links.should have(1).items
    org.org_network_links.should have(1).items
  end
  
  it "parses VDC links" do
    org_href = "https://some.vcloud.com/api/org/aaa-bbb-ccc-ddd-eee-fff"
    org = VCloud::Org.from_reference(VCloud::Reference.new({:href => org_href}), @session)
    vdc_links = org.get_vdc_links_by_name
    
    WebMock.should have_requested(:get, org_href).
      with(:headers => {'Accept'=>'application/vnd.vmware.vcloud.org+xml;version=1.5', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby', 'X-Vcloud-Authorization'=>'abc123xyz'})
    
    vdc_links.should have(1).item
    vdc_links["SomeVDC"].name.should == "SomeVDC"
    vdc_links["SomeVDC"].href.should == "https://some.vcloud.com/api/vdc/aaa-bbb-ccc-ddd-eee-fff"
  end
  
  it "parses Catalog links" do
    org_href = "https://some.vcloud.com/api/org/aaa-bbb-ccc-ddd-eee-fff"
    org = VCloud::Org.from_reference(VCloud::Reference.new({:href => org_href}), @session)
    catalog_links = org.get_catalog_links_by_name
    
    WebMock.should have_requested(:get, org_href).
      with(:headers => {'Accept'=>'application/vnd.vmware.vcloud.org+xml;version=1.5', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby', 'X-Vcloud-Authorization'=>'abc123xyz'})
    
    catalog_links.should have(1).item
    catalog_links["SuperCool Catalog"].name.should == "SuperCool Catalog"
    catalog_links["SuperCool Catalog"].href.should == "https://some.vcloud.com/api/catalog/aaa-bbb-ccc-ddd-eee-fff"
  end
  
end