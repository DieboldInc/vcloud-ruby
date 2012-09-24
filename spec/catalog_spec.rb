require 'spec_helper'

include WebMock::API

describe VCloud::Catalog do
  
  before(:each) do
    stub_request(:get, "https://vcloud.diebold.dev/api/catalog/aaa-bbb-ccc-ddd-eee-fff").
             with(:headers => {'Accept'=>'application/vnd.vmware.vcloud.catalog+xml;version=1.5', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby', 'X-Vcloud-Authorization'=>'abc123xyz'}).
             to_return(:status => 200, :body => VCloud::Test::Data::CATALOG_XML, :headers => {})
  end
  
  it "retrieves a catalog" do
    catalog_href = "https://vcloud.diebold.dev/api/catalog/aaa-bbb-ccc-ddd-eee-fff"
    catalog = VCloud::Catalog.from_reference(VCloud::CatalogReference.new({:href => catalog_href}), @session)
    
    WebMock.should have_requested(:get, catalog_href).
      with(:headers => {'Accept'=>'application/vnd.vmware.vcloud.catalog+xml;version=1.5', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby', 'X-Vcloud-Authorization'=>'abc123xyz'})
    
    catalog.name.should == "SuperCool Catalog"
    catalog.links.should have(1).items
    catalog.catalog_item_references.should have(1).items
  end
  
  it "parses catalog item references" do
    catalog_href = "https://vcloud.diebold.dev/api/catalog/aaa-bbb-ccc-ddd-eee-fff"
    catalog = VCloud::Catalog.from_reference(VCloud::CatalogReference.new({:href => catalog_href}), @session)
    
    WebMock.should have_requested(:get, catalog_href).
      with(:headers => {'Accept'=>'application/vnd.vmware.vcloud.catalog+xml;version=1.5', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby', 'X-Vcloud-Authorization'=>'abc123xyz'})
    
    catalog.catalog_item_references.first.name.should == "Ubuntu 10.04.4 LTS"
    catalog.catalog_item_references.first.href.should == "https://some.vcloud.com/api/catalogItem/aaa-bbb-ccc-ddd-eee-fff"
  end
  
  
end