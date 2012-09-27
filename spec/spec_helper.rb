require 'webmock/rspec'

require_relative '../lib/vcloud'

RSpec.configure do |config|
  config.before(:each) {
    stub_request(:post, "https://someuser%40someorg:password@some.vcloud.com/api/sessions").
             with(:headers => {'Accept'=>'application/*+xml;version=1.5'}).
             to_return(:status => 200, :body => fixture_file('session.xml'), :headers => {:x_vcloud_authorization => "abc123xyz"})
             
    @session = VCloud::Client.new('https://some.vcloud.com/api/', '1.5')
    @session.login('someuser@someorg', 'password')
    VCloud::Session.set_session(@session)
  }
end

def fixture_file(filename)
  File.read(File.dirname(__FILE__) + "/fixtures/#{filename}")
end

module VCloud
  module Test
    module Data          
      VAPP_TEMPLATE_PARAMS = %q{<?xml version="1.0" encoding="UTF-8"?>
      <InstantiateVAppTemplateParams
         xmlns="http://www.vmware.com/vcloud/v1.5"
         name="Linux FTP server"
         deploy="true"
         powerOn="true"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xmlns:ovf="http://schemas.dmtf.org/ovf/envelope/1">
         <Description>Ruby VCloud RSpec Test</Description>
         <InstantiationParams>
            <NetworkConfigSection>
               <ovf:Info>Configuration parameters for logical networks</ovf:Info>
               <NetworkConfig
                  networkName="Dev VLAN">
                  <Configuration>
                     <ParentNetwork
                        href="https://some.vcloud.com/api/network/aaa-bbb-ccc-ddd-eee-fff" />
                     <FenceMode>bridged</FenceMode>
                  </Configuration>
               </NetworkConfig>
            </NetworkConfigSection>
         </InstantiationParams>
         <Source
            href="https://some.vcloud.com/api/vAppTemplate/vappTemplate-aaa-bbb-ccc-ddd-eee-fff" />
      </InstantiateVAppTemplateParams>}
      
      NETWORK_CONFIG_XML = %q{<NetworkConfig networkName="TestVappNetworkConfigNetwork">
        <Configuration>
          <ParentNetwork href=""/>
          <FenceMode>bridged</FenceMode>
        </Configuration>
      </NetworkConfig>}
      
      NETWORK_CONFIG_SECTION_XML = %q{<NetworkConfigSection xmlns="http://www.vmware.com/vcloud/v1.5" xmlns:ovf="http://schemas.dmtf.org/ovf/envelope/1">
        <ovf:Info>Configuration parameters for logical networks</ovf:Info>
        <NetworkConfig networkName="TestVappNetworkConfigNetwork">
        <Configuration>
          <ParentNetwork href=""/>
          <FenceMode>bridged</FenceMode>
        </Configuration>
      </NetworkConfig>
      </NetworkConfigSection>}
      
      INSTANTIATE_VAPP_TEMPLATE_PARAMS = %q{<?xml version="1.0" encoding="UTF-8"?>
      <InstantiateVAppTemplateParams xmlns="http://www.vmware.com/vcloud/v1.5" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ovf="http://schemas.dmtf.org/ovf/envelope/1" name="SomeVAppTemplateParams" deploy="true" powerOn="false">
        <Description>some descriptive string</Description>
        <InstantiationParams/>
        <Source href=""/>
      </InstantiateVAppTemplateParams>}
    end
  end
end