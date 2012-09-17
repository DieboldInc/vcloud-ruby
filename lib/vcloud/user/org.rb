module VCloud
  class Org
    include ParsesXml
    include RestApi
    
    has_links

    attr_reader :name, :type, :href, :id, :vdcs, :catalogs, :networks, :vdc_links, :catalog_links, :org_network_links
    
    def self.type
      VCloud::Constants::ContentType::ORG
    end

    def initialize(args)
      @type = self.class.type
      
      @name = args[:name]
      @href = args[:href]
      @id = args[:id]
      
      @vdc_links = args[:vdc_links]
      @catalog_links = args[:catalog_links]
      @org_network_links = args[:org_network_links]
    end

    def self.from_reference(ref, session = VCloud::Session.current_session)
      obj = Org.new({:href => ref.href})
      obj.refresh
      obj
    end
    
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
            
      @name = parsed_xml[:doc].root.attr("name")
      @href = parsed_xml[:doc].root.attr("href")
      @id = parsed_xml[:doc].root.attr("id")
    end
    
  end
end