module VCloud
  class VAppNetworkConfig
    
    attr_accessor :network_name, :parent_network, :fence_mode
    
    def to_xml
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.NetworkConfig(:networkName => @network_name) {
          xml.Configuration {
            xml.ParentNetwork(:href => @parent_network.href)
            xml.FenceMode @fence_mode
          }
        }
      end
      builder.to_xml
    end
    
  end
end