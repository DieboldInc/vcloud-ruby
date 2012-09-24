module VCloud
  class NetworkConfiguration
    include ParsesXml
    
    tag 'NetworkConfiguration'
    attribute :network_name, String, :tag => 'networkName'
    element :parent_network, ParentNetworkReference, :xpath => 'Configuration/.'
    element :fence_mode, String, :tag => 'FenceMode', :xpath => 'Configuration/FenceMode'
    
    
  end
end