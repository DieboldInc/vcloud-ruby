module VCloud
  class Vdc < BaseVCloudEntity
    include ParsesXml
    
    has_type VCloud::Constants::ContentType::VDC
    has_default_attributes
    has_links
    has_reference :network_references, VCloud::Constants::Xpath::NETWORK_REFERENCE
    
    def get_network_refs_by_name
      refs_by_name = {}
      @network_references.each do |item|
        refs_by_name[item.name] = item
      end
      return refs_by_name
    end
  end
end