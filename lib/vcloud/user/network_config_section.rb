module VCloud
  class NetworkConfiguration
  end
  
  class NetworkConfigSection
    include ParsesXml
  
    register_namespace 'xmlns', 'http://www.vmware.com/vcloud/v1.5'
    register_namespace 'ovf', 'http://schemas.dmtf.org/ovf/envelope/1'
    namespace 'xmlns'
    tag 'NetworkConfigSection'
    element :info, String, :tag => 'Info', :namespace => 'ovf'
    has_many :network_configurations, NetworkConfiguration
    
    def initialize
      @info = 'Configuration parameters for logical networks'
      @network_configurations = []
    end
  end
end