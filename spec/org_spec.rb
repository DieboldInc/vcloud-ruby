require 'spec_helper'

include WebMock::API

describe VCloud::Org do
  before(:each) do
    @org = VCloud::Org.from_xml(fixture_file('org.xml'))
  end

  describe 'parses xml #from_xml' do    
    it 'should have correct values' do
      @org.name.should == 'someorg'                      
      @org.id.should == 'urn:vcloud:org:aaa-bbb-ccc-ddd-eee-fff'
      @org.type.should == 'application/vnd.vmware.vcloud.org+xml'
      @org.href.should == 'https://some.vcloud.com/api/org/aaa-bbb-ccc-ddd-eee-fff'
      @org.description.should == 'This is an example organization'
      @org.full_name.should == 'Example Organization'
      @org.links.should have(6).items
    end
    
    it 'should filter #vdc_links' do
      @org.vdc_links.should have(1).item
      @org.vdc_links[0].type.should == "application/vnd.vmware.vcloud.vdc+xml"
    end
    
    it 'should filter #catalog_links' do
      @org.catalog_links.should have(1).item
      @org.catalog_links[0].type.should == "application/vnd.vmware.vcloud.catalog+xml"
    end
    
    it 'should filter #org_network_links' do
      @org.org_network_links.should have(1).item
      @org.org_network_links[0].type.should == "application/vnd.vmware.vcloud.orgNetwork+xml"      
    end
    
    it 'should #get_catalog_links_by_name' do
      hash = @org.get_catalog_links_by_name

      hash.should have(1).items
      hash['SuperCool Catalog'].href.should == 'https://some.vcloud.com/api/catalog/aaa-bbb-ccc-ddd-eee-fff'
    end     
    
    it 'should #get_vdc_links_by_name' do
      hash = @org.get_vdc_links_by_name
      
      hash.should have(1).items
      hash['SomeVDC'].href.should == 'https://some.vcloud.com/api/vdc/aaa-bbb-ccc-ddd-eee-fff'
    end                                                                                      
  end
  
  it 'should #get_catalog_from_name if name exists' do
    link = @org.get_catalog_links_by_name['SuperCool Catalog']
    VCloud::Catalog.should_receive(:from_reference).with(link).and_return('not nil')
    
    catalog = @org.get_catalog_from_name('SuperCool Catalog')
    
    catalog.should_not be_nil
  end

  it 'should return nil #get_catalog_from_name if name does not exist' do
    catalog = @org.get_catalog_from_name('no exist')
    
    catalog.should be_nil
  end   
  
  it 'should #get_vdc_from_name if name exists' do
    link = @org.get_vdc_links_by_name['SomeVDC']
    VCloud::Vdc.should_receive(:from_reference).with(link).and_return('not nil')
    
    vdc = @org.get_vdc_from_name('SomeVDC')
    
    vdc.should_not be_nil
  end
  
  it 'should return nil #get_vdc_from_name if name does not exist' do
    vdc = @org.get_vdc_from_name('no exist')
    
    vdc.should be_nil
  end  
  
  it 'should retrieve organization #from_reference' do
    stub_request(:get, "https://some.vcloud.com/api/org/aaa-bbb-ccc-ddd-eee-fff").
      with(:headers => {'Accept'=>'application/vnd.vmware.vcloud.org+xml;version=1.5', 'X-Vcloud-Authorization'=>'abc123xyz'}).
      to_return(:status => 200, :body => fixture_file('org.xml'))  
    
    org = VCloud::Org.from_reference(stub(:href => 'https://some.vcloud.com/api/org/aaa-bbb-ccc-ddd-eee-fff'), @session)
    
    WebMock.should have_requested(:get, 'https://some.vcloud.com/api/org/aaa-bbb-ccc-ddd-eee-fff').
      with(:headers => {'Accept'=>'application/vnd.vmware.vcloud.org+xml;version=1.5', 'X-Vcloud-Authorization'=>'abc123xyz'})

    org.name.should == 'someorg'                      
    org.id.should == 'urn:vcloud:org:aaa-bbb-ccc-ddd-eee-fff'
    org.type.should == 'application/vnd.vmware.vcloud.org+xml'
    org.href.should == 'https://some.vcloud.com/api/org/aaa-bbb-ccc-ddd-eee-fff'
    org.description.should == 'This is an example organization'
    org.full_name.should == 'Example Organization'
    org.links.should have(6).items
  end   
end    
