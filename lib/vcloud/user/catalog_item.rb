module VCloud
  class CatalogItem
    include ParsesXml
    include RestApi
    
    has_links
    has_reference :entity_references, VCloud::Constants::Xpath::ENTITY_REFERENCE
    has_default_attributes
    
    def self.type
      VCloud::Constants::ContentType::VAPP_TEMPLATE
    end
    
    def initialize(args)

    end
    
    def self.from_reference(ref, session = VCloud::Session.current_session)
      obj = new({:href => ref.href})
      obj.refresh    
      obj
    end
  end
end