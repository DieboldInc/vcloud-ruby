module VCloud
  class NetworkConfigSection < BaseVCloudEntity
    include ParsesXml
    
    has_type VCloud::Constants::ContentType::NETWORK_CONFIG_SECTION
    has_default_attributes
    has_links
    
    attr_accessor :configurations
  
    def to_xml
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.NetworkConfigSection {
          @configurations.each do |config|
            xml << config.to_xml
          end
        }
      end
      builder.to_xml
    end
  
  end
end