module VCloud
  # Represents a vApp network configuration
  class NetworkConfig
    include ParsesXml

    tag 'NetworkConfig'
    attribute :network_name, String, :tag => 'networkName'
    wrap 'Configuration' do     
      element :parent_network_reference, 'VCloud::Reference', :tag => 'ParentNetwork'
      element :fence_mode, String, :tag => 'FenceMode'
    end
    
    # Networking fence modes
    module FenceMode
      BRIDGED = 'bridged'
      ISOLATED = 'isolated'
      NAT = 'natRouted'
    end    
  end
end