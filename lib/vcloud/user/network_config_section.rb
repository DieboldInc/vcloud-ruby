module VCloud
  # Container for vApp networks
  class NetworkConfigSection
    include ParsesXml
  
    register_namespace 'xmlns', VCloud::Constants::NameSpace::V1_5
    register_namespace 'ovf', VCloud::Constants::NameSpace::OVF

    tag 'NetworkConfigSection'
    attribute :href, String
    attribute :type, String
    element :info, String, :tag => 'Info', :namespace => 'ovf'
    has_many :network_configs, 'VCloud::NetworkConfig', :tag => 'NetworkConfig'
    
    def initialize
      @info = 'Configuration parameters for logical networks'
      @network_configs = []
    end
  end
end