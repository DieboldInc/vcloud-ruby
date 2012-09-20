require 'spec_helper'

include WebMock::API

describe VCloud::CatalogItem do
  
  before(:each) do
    stub_request(:get, "https://vcloud.diebold.dev/api/catalogItem/aaa-bbb-ccc-ddd-eee-fff").
             with(:headers => {'Accept'=>'application/vnd.vmware.vcloud.catalogItem+xml;version=1.5', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby', 'X-Vcloud-Authorization'=>'abc123xyz'}).
             to_return(:status => 200, :body => VCloud::Test::Data::CATALOG_ITEM_XML, :headers => {})
  end
  
  it "retrieves a catalog item" do
    catalog_item_href = "https://vcloud.diebold.dev/api/catalogItem/aaa-bbb-ccc-ddd-eee-fff"
    catalog_item = VCloud::CatalogItem.from_reference(VCloud::Reference.new({:href => catalog_item_href}), @session)
    
    WebMock.should have_requested(:get, catalog_item_href).
      with(:headers => {'Accept'=>'application/vnd.vmware.vcloud.catalogItem+xml;version=1.5', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby', 'X-Vcloud-Authorization'=>'abc123xyz'})
    
    catalog_item.name.should == "Ubuntu 10.04.4 LTS"
    catalog_item.href.should == "https://some.vcloud.com/api/catalogItem/aaa-bbb-ccc-ddd-eee-fff"
    catalog_item.links.should have(2).items
  end  
  
  it "retrieves a catalog item entity reference" do
    catalog_item_href = "https://vcloud.diebold.dev/api/catalogItem/aaa-bbb-ccc-ddd-eee-fff"
    catalog_item = VCloud::CatalogItem.from_reference(VCloud::Reference.new({:href => catalog_item_href}), @session)
    
    WebMock.should have_requested(:get, catalog_item_href).
      with(:headers => {'Accept'=>'application/vnd.vmware.vcloud.catalogItem+xml;version=1.5', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby', 'X-Vcloud-Authorization'=>'abc123xyz'})
    
    catalog_item.entity_reference.name.should == "Ubuntu 10.04.4 LTS"  
    catalog_item.entity_reference.href.should == "https://some.vcloud.com/api/vAppTemplate/vappTemplate-aaa-bbb-ccc-ddd-eee-fff"
  end
end