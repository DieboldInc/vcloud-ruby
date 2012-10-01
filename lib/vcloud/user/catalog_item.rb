module VCloud
  
  # Contains a reference to a VappTemplate or Media object and related metadata
  class CatalogItem < BaseVCloudEntity
    has_type VCloud::Constants::ContentType::CATALOG_ITEM
    tag 'CatalogItem'
    has_default_attributes
    has_links
    has_one :entity_reference, 'VCloud::Reference', :tag => 'Entity'
  end
end