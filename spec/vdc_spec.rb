require 'spec_helper'

include WebMock::API

describe VCloud::Vdc do
  
  before(:each) do
    stub_request(:get, "https://some.vcloud.com/api/vdc/aaa-bbb-ccc-ddd-eee-fff").
             with(:headers => {'Accept'=>'application/vnd.vmware.vcloud.vdc+xml;version=1.5', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby', 'X-Vcloud-Authorization'=>'abc123xyz'}).
             to_return(:status => 200, :body => VCloud::Test::Data::VDC_XML, :headers => {})
    
    
    stub_request(:post, "https://some.vcloud.com/api/vdc/aaa-bbb-ccc-ddd-eee-fff/action/instantiateVAppTemplate").
             with({'Accept'=>'application/*+xml;version=1.5', 'Accept-Encoding'=>'gzip, deflate', 'Content-Type'=>'application/vnd.vmware.vcloud.instantiateVAppTemplateParams+xml', 'User-Agent'=>'Ruby', 'X-Vcloud-Authorization'=>'abc123xyz'}).
             to_return(:status => 200, :body => VCloud::Test::Data::VAPP_XML, :headers => {})
  end
  
  it "retrieves a VDC" do
    vdc_href = "https://some.vcloud.com/api/vdc/aaa-bbb-ccc-ddd-eee-fff"
    vdc = VCloud::Vdc.from_reference(VCloud::Reference.new({:href => vdc_href}), @session)
    
    WebMock.should have_requested(:get, vdc_href).
      with(:headers => {'Accept'=>'application/vnd.vmware.vcloud.vdc+xml;version=1.5', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby', 'X-Vcloud-Authorization'=>'abc123xyz'})
    
    vdc.name.should == "TestVDC"
    vdc.href.should == "https://some.vcloud.com/api/vdc/aaa-bbb-ccc-ddd-eee-fff"
    vdc.links.should have(10).items
  end
  
  it "pareses a network references" do
    vdc_href = "https://some.vcloud.com/api/vdc/aaa-bbb-ccc-ddd-eee-fff"
    vdc = VCloud::Vdc.from_reference(VCloud::Reference.new({:href => vdc_href}), @session)
    
    WebMock.should have_requested(:get, vdc_href).
      with(:headers => {'Accept'=>'application/vnd.vmware.vcloud.vdc+xml;version=1.5', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby', 'X-Vcloud-Authorization'=>'abc123xyz'})
    
    vdc.network_references.should have(1).item
    vdc.network_references.first.name.should == "Dev VLAN"
    vdc.network_references.first.href.should == "https://some.vcloud.com/api/network/aaa-bbb-ccc-ddd-eee-fff"
  end
  
  it "instantiates a vapp template" do
    vdc_href = "https://some.vcloud.com/api/vdc/aaa-bbb-ccc-ddd-eee-fff"
    vapp_href = "https://some.vcloud.com/api/vApp/vapp-aaa-bbb-ccc-ddd-eee-fff"
    instantiate_vapp_template_url = "https://some.vcloud.com/api/vdc/aaa-bbb-ccc-ddd-eee-fff/action/instantiateVAppTemplate"
    
    vdc = VCloud::Vdc.from_reference(VCloud::Reference.new({:href => vdc_href}), @session)
    
    net_section = VCloud::NetworkConfigSection.new
    net_config = VCloud::VAppNetworkConfig.new
    net_config.network_name = "TestVappNetworkConfigNetwork"
    net_config.parent_network_ref = VCloud::Reference.new({})
    net_config.fence_mode = 'bridged'
    net_section.network_configurations << net_config

    vapp_params = VCloud::InstantiateVAppTemplateParams.new
    vapp_params.name = 'SomeVAppTemplateParams'
    vapp_params.description = 'some descriptive string'
    vapp_params.source = VCloud::Reference.new({})
    vapp_params.instantiation_param_items << net_section
    
    result = vdc.instantiate_vapp_template(vapp_params)
    
    WebMock.should have_requested(:get, vdc_href).
      with(:headers => {'Accept'=>'application/vnd.vmware.vcloud.vdc+xml;version=1.5', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby', 'X-Vcloud-Authorization'=>'abc123xyz'})
    WebMock.should have_requested(:post, instantiate_vapp_template_url).
      with(:headers => {'Accept'=>'application/*+xml;version=1.5', 'Accept-Encoding'=>'gzip, deflate', 'Content-Type'=>'application/vnd.vmware.vcloud.instantiateVAppTemplateParams+xml', 'User-Agent'=>'Ruby', 'X-Vcloud-Authorization'=>'abc123xyz'})
  
    result.name.should == 'Linux FTP server'
    result.href.should == vapp_href
  end
  
end
