module VCloud
  class CatalogItem < BaseVCloudEntity
    include ParsesXml
    
    has_type VCloud::Constants::ContentType::CATALOG_ITEM
    tag 'CatalogItem'
    has_default_attributes
    has_links
    has_one :entity_reference, Reference, :tag => 'Entity'
  end
end