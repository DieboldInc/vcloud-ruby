module VCloud
  class Catalog < BaseVCloudEntity

    has_type VCloud::Constants::ContentType::CATALOG
    tag 'Catalog'
    has_links
    has_default_attributes
    wrap 'CatalogItems' do
      has_many :catalog_item_references, 'VCloud::Reference', :tag => "CatalogItem"
    end
    element :is_published, Boolean, :tag => 'IsPublished'

    def get_catalog_item_refs_by_name
      Hash[catalog_item_references.collect{ |i| [i.name, i] }]
    end
    
    def get_catalog_item_from_name(name, session = self.session)
      catalog_items = get_catalog_item_refs_by_name
      item = catalog_items[name] or return nil
      CatalogItem.from_reference(item, session)
    end
  end
end