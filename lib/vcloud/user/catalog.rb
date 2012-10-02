module VCloud
  # Contains a collection of CatalogItem references
  class Catalog < BaseVCloudEntity

    has_type VCloud::Constants::ContentType::CATALOG
    tag 'Catalog'
    has_links
    has_default_attributes
    wrap 'CatalogItems' do
      has_many :catalog_item_references, 'VCloud::Reference', :tag => "CatalogItem"
    end
    element :is_published, Boolean, :tag => 'IsPublished'

    # Returns a hash of of all CatalogItem references, keyed by the CatalogItem name
    #
    # @return [Hash{String => VCloud::Reference}] Reference to all CatalogsItems in the Catalog, keyed by name
    def get_catalog_item_references_by_name
      Hash[catalog_item_references.collect{ |i| [i.name, i] }]
    end
    
    # Retrieves an CatalogItem, assuming the user has access to it
    #
    # @param [String] name CatalogItem name
    # @param [VCloud::Client] session Session to use to retrieve the CatalogItem
    # @return [VCloud::CatalogItem] CatalogItem object
    def get_catalog_item_from_name(name, session = self.session)
      catalog_items = get_catalog_item_references_by_name
      item = catalog_items[name] or return nil
      CatalogItem.from_reference(item, session)
    end
  end
end