module VCloud
  class CatalogItem < BaseVCloudEntity
    
    has_type VCloud::Constants::ContentType::CATALOG_ITEM
    tag 'CatalogItem'
    has_default_attributes
    has_links
    has_one :entity_reference, 'VCloud::Reference', :tag => 'Entity'
  end
end