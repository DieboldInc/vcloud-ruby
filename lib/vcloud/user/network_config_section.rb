module VCloud
  class NetworkConfigSection
    
  
    attr_accessor :configurations
        
    def initialize
      @configurations = []
    end
  
    def to_xml
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.NetworkConfigSection(
                    :xmlns => VCloud::Constants::NameSpace::V1_5,
                    'xmlns:ovf' => VCloud::Constants::NameSpace::OVF) {
          xml['ovf'].Info 'Configuration parameters for logical networks'
          @configurations.each do |config|
            xml << config.to_xml
          end
        }
      end
      builder.doc.root.to_xml
    end
  
  end
end