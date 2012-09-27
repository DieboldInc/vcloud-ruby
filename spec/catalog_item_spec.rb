require 'spec_helper'

include WebMock::API

describe VCloud::CatalogItem do
  describe "when parsing #from_xml" do
    before(:each) do
      @item = VCloud::CatalogItem.from_xml(fixture_file('catalog_item.xml'))
    end    
        
    it 'should have correct values' do
      @item.name.should == 'Ubuntu 10.04.4 LTS'
      @item.id.should == 'urn:vcloud:catalogitem:aaa-bbb-ccc-ddd-eee-fff'
      @item.type.should == 'application/vnd.vmware.vcloud.catalogItem+xml'
      @item.href.should == 'https://some.vcloud.com/api/catalogItem/aaa-bbb-ccc-ddd-eee-fff'
      @item.links.should have(2).items
      @item.entity_reference.name.should == 'Ubuntu 10.04.4 LTS'
      @item.entity_reference.href.should == 'https://some.vcloud.com/api/vAppTemplate/vappTemplate-aaa-bbb-ccc-ddd-eee-fff'
      @item.entity_reference.type.should == 'application/vnd.vmware.vcloud.vAppTemplate+xml'
    end
  end
  
  it 'should retrieve CatalogItem #from_reference' do
    stub_request(:get, "https://vcloud.diebold.dev/api/catalogItem/aaa-bbb-ccc-ddd-eee-fff").
      with(:headers => {'Accept'=>'application/vnd.vmware.vcloud.catalogItem+xml;version=1.5', 'X-Vcloud-Authorization'=>'abc123xyz'}).
      to_return(:status => 200, :body => fixture_file('catalog_item.xml'))
   
      item = VCloud::CatalogItem.from_reference(stub(:href => 'https://vcloud.diebold.dev/api/catalogItem/aaa-bbb-ccc-ddd-eee-fff'), @session)

      WebMock.should have_requested(:get, 'https://vcloud.diebold.dev/api/catalogItem/aaa-bbb-ccc-ddd-eee-fff').
        with(:headers => {'Accept'=>'application/vnd.vmware.vcloud.catalogItem+xml;version=1.5', 'X-Vcloud-Authorization'=>'abc123xyz'})

      item.id.should == 'urn:vcloud:catalogitem:aaa-bbb-ccc-ddd-eee-fff'
  end  
end