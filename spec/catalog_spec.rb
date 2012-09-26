require 'spec_helper'

include WebMock::API

describe VCloud::Catalog do
  before(:each) do
    @catalog = VCloud::Catalog.from_xml(fixture_file('catalog.xml'))
  end
  
  describe 'parses xml' do
    it '#from_xml should have correct values' do
      @catalog.name.should == 'SuperCool Catalog'
      @catalog.id.should == 'urn:vcloud:catalog:aaa-bbb-ccc-ddd-eee-fff'
      @catalog.type.should == 'application/vnd.vmware.vcloud.catalog+xml'
      @catalog.href.should == 'https://some.vcloud.com/api/catalog/aaa-bbb-ccc-ddd-eee-fff'
      @catalog.links.should have(1).items
      @catalog.catalog_item_references.should have(1).items
      @catalog.is_published.should == true
    end
    
    it 'should #get_catalog_item_refs_by_name' do
      hash = @catalog.get_catalog_item_refs_by_name
      
      hash.should have(1).items
      hash['Ubuntu 10.04.4 LTS'].href.should == 'https://some.vcloud.com/api/catalogItem/aaa-bbb-ccc-ddd-eee-fff'      
    end
  end  
  
  it 'should #get_catalog_item_from_name if name exists' do
    ref = @catalog.get_catalog_item_refs_by_name()['Ubuntu 10.04.4 LTS']
    VCloud::CatalogItem.should_receive(:from_reference).with(ref).and_return('not nil')
    
    item = @catalog.get_catalog_item_from_name('Ubuntu 10.04.4 LTS')
    
    item.should_not be_nil
  end
  
  it 'should return nil #get_catalog_item_from_name if name does not exist' do
    item = @catalog.get_catalog_item_from_name('not exist')
    
    item.should be_nil
  end

  it "should retrieve catalog #from_reference" do
    stub_request(:get, "https://vcloud.diebold.dev/api/catalog/aaa-bbb-ccc-ddd-eee-fff").
      with(:headers => {'Accept'=>'application/vnd.vmware.vcloud.catalog+xml;version=1.5', 'X-Vcloud-Authorization'=>'abc123xyz'}).
      to_return(:status => 200, :body => fixture_file('catalog.xml'))     

    catalog = VCloud::Catalog.from_reference(stub(:href => 'https://vcloud.diebold.dev/api/catalog/aaa-bbb-ccc-ddd-eee-fff'), @session)

    WebMock.should have_requested(:get, 'https://vcloud.diebold.dev/api/catalog/aaa-bbb-ccc-ddd-eee-fff').
      with(:headers => {'Accept'=>'application/vnd.vmware.vcloud.catalog+xml;version=1.5', 'X-Vcloud-Authorization'=>'abc123xyz'})

    @catalog.name.should == 'SuperCool Catalog'
    @catalog.id.should == 'urn:vcloud:catalog:aaa-bbb-ccc-ddd-eee-fff'
    @catalog.type.should == 'application/vnd.vmware.vcloud.catalog+xml'
    @catalog.href.should == 'https://some.vcloud.com/api/catalog/aaa-bbb-ccc-ddd-eee-fff'
    @catalog.links.should have(1).items
    @catalog.catalog_item_references.should have(1).items
    @catalog.is_published.should == true  
  end
end