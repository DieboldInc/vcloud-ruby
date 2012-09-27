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
      

    end
  end
end