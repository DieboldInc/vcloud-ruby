module VCloud
  class NetworkConfiguration
    include ParsesXml
    
    tag 'NetworkConfiguration'
    attribute :network_name, String, :tag => 'networkName'
    wrap 'Configuration' do
      element :parent_network, 'VCloud::Reference', :tag => 'ParentNetwork'
      element :fence_mode, String, :tag => 'FenceMode'
    end
    
    
  end
end