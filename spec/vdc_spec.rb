require 'spec_helper'

include WebMock::API

describe VCloud::Vdc do
  before(:each) do
    @vdc = VCloud::Vdc.from_xml(fixture_file('vdc.xml'))    
  end
  
  describe 'when parsing xml #from_xml' do 
    it 'should have correct values' do
      @vdc.name.should == 'TestVDC'
      @vdc.id.should == 'urn:vcloud:vdc:aaa-bbb-ccc-ddd-eee-fff'
      @vdc.type.should == 'application/vnd.vmware.vcloud.vdc+xml'
      @vdc.href.should == 'https://some.vcloud.com/api/vdc/aaa-bbb-ccc-ddd-eee-fff'
    end
    
    it 'should parese a network references' do  
      @vdc.network_references.should_not be_nil
      @vdc.network_references.should have(1).items
      @vdc.network_references.first.name.should == "Dev VLAN"
      @vdc.network_references.first.href.should == "https://some.vcloud.com/api/network/aaa-bbb-ccc-ddd-eee-fff"
    end
    
    it 'should parse links' do
      @vdc.links.should_not be_nil
      @vdc.links.should have(10).items
      @vdc.links.first.type.should == 'application/vnd.vmware.vcloud.org+xml'
      @vdc.links.first.href.should == 'https://some.vcloud.com/api/org/aaa-bbb-ccc-ddd-eee-fff'
    end
    
    it 'should #get_network_references_by_name' do
      refs_by_name = @vdc.get_network_references_by_name
      refs_by_name.should have(1).items
      
      refs_by_name['Dev VLAN'].type.should == 'application/vnd.vmware.vcloud.network+xml'
      refs_by_name['Dev VLAN'].name.should == 'Dev VLAN'
      refs_by_name['Dev VLAN'].href.should == 'https://some.vcloud.com/api/network/aaa-bbb-ccc-ddd-eee-fff'
    end
  end
  
  it "should retrieve VDC #from_reference" do
    stub_request(:get, "https://some.vcloud.com/api/vdc/aaa-bbb-ccc-ddd-eee-fff").
      with(:headers => {'Accept'=>'application/vnd.vmware.vcloud.vdc+xml;version=1.5', 'X-Vcloud-Authorization'=>'abc123xyz'}).
      to_return(:status => 200, :body => fixture_file('vdc.xml'))
    
    vdc = VCloud::Vdc.from_reference(stub(:href => 'https://some.vcloud.com/api/vdc/aaa-bbb-ccc-ddd-eee-fff'), @session)
    
    WebMock.should have_requested(:get, 'https://some.vcloud.com/api/vdc/aaa-bbb-ccc-ddd-eee-fff').
      with(:headers => {'Accept'=>'application/vnd.vmware.vcloud.vdc+xml;version=1.5', 'X-Vcloud-Authorization'=>'abc123xyz'})
        
    vdc.id.should == "urn:vcloud:vdc:aaa-bbb-ccc-ddd-eee-fff"
  end
  
  it "should #instantiate_vapp_template" do    
    net_section = VCloud::NetworkConfigSection.new
    net_config = VCloud::NetworkConfig.new
    net_config.network_name = "TestVappNetworkConfigNetwork"
    net_config.parent_network_reference = VCloud::Reference.new({})
    net_config.fence_mode = 'bridged'
    net_section.network_configs << net_config

    vapp_params = VCloud::InstantiateVAppTemplateParams.new
    vapp_params.name = 'SomeVAppTemplateParams'
    vapp_params.description = 'some descriptive string'
    vapp_params.source_reference = VCloud::Reference.new({})
    vapp_params.network_config_section = net_section
    
    stub_request(:post, 'https://some.vcloud.com/api/vdc/aaa-bbb-ccc-ddd-eee-fff/action/instantiateVAppTemplate').
      with(:headers => {'Accept'=>'application/*+xml;version=1.5', 'Content-Type'=>'application/vnd.vmware.vcloud.instantiateVAppTemplateParams+xml', 'X-Vcloud-Authorization'=>'abc123xyz'}).
      to_return(:status => 200, :body => fixture_file('vapp.xml'))
    
    vapp = @vdc.instantiate_vapp_template(vapp_params, @session)
    
    WebMock.should have_requested(:post, 'https://some.vcloud.com/api/vdc/aaa-bbb-ccc-ddd-eee-fff/action/instantiateVAppTemplate').
      with(:headers => {'Accept'=>'application/*+xml;version=1.5', 'Accept-Encoding'=>'gzip, deflate', 'Content-Type'=>'application/vnd.vmware.vcloud.instantiateVAppTemplateParams+xml', 'X-Vcloud-Authorization'=>'abc123xyz'})
  
    vapp.id.should == 'urn:vcloud:vapp:aaa-bbb-ccc-ddd-eee-fff'

    vapp.session.should == @session
  end
  
end
