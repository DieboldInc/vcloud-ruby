module VCloud
  class Org < BaseVCloudEntity
    include ParsesXml
    
    has_type VCloud::Constants::ContentType::ORG
    has_links
    has_default_attributes
    
    attr_reader :vdc_links, :catalog_links, :org_network_links
    
    def get_catalog_links_by_name()
      catalog_refs = {}
      @catalog_links.each do |catalog_link|
        catalog_refs[catalog_link.name] = catalog_link
      end
      catalog_refs
    end
    
    def get_catalog_from_name(name)
      catalogs = get_catalog_links_by_name
      link = catalogs[name]
      Catalog.from_reference(link)
    end
    
    def parse_xml(xml)
      parsed_xml = super(xml)
      
      @vdc_links = []
      @catalog_links = []
      @org_network_links = []
      
      @links.each do |link|
        case link.type
        when VCloud::Constants::ContentType::VDC
          vdc_links << link
        when VCloud::Constants::ContentType::CATALOG
          catalog_links << link
        when VCloud::Constants::ContentType::ORG_NETWORK
          org_network_links << link
        end
      end
    end
    
  end
end