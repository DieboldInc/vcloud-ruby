module VCloud
  class Catalog
    include ParsesXml
    include RestApi
    include Session

    has_links
    has_reference :catalog_item_references, VCloud::Constants::Xpath::CATALOG_ITEM_REFERENCE
    has_default_attributes
    
    def self.type
      VCloud::Constants::ContentType::CATALOG
    end
    
    def initialize(args)
      @name = args[:name]
      @id = args[:id]
      @type = args[:type]
      @href = args[:href]

      @catalog_items = []
    end
    
    def self.from_reference(ref, session = VCloud::Session.current_session)
      obj = new({:href => ref.href})
      obj.refresh    
      obj
    end

  end
end