module VCloud
  class CatalogItem < BaseVCloudEntity
    include ParsesXml
    
    has_type VCloud::Constants::ContentType::CATALOG_ITEM
    has_links
    has_reference :entity_references, VCloud::Constants::Xpath::ENTITY_REFERENCE
    has_default_attributes
    
    def entity_reference
      @entity_references.first
    end
    
  end
end