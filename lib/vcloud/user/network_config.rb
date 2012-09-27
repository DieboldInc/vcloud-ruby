module VCloud
  class NetworkConfig
    include ParsesXml

    tag 'NetworkConfig'
    attribute :network_name, String, :tag => 'networkName'
    wrap 'Configuration' do     
      element :parent_network_reference, 'VCloud::Reference', :tag => 'ParentNetwork'
      element :fence_mode, String, :tag => 'FenceMode'
    end
    
    module FenceMode
      BRIDGED = 'bridged'
      ISOLATED = 'isolated'
      NAT = 'natRouted'
    end    
  end
end