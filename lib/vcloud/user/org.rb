module VCloud
  class Org
    include ParsesXml
    
    has_links

    attr_reader :type, :name, :href, :id, :vdcs, :catalogs, :networks, :vdc_links, :catalog_links, :org_network_links

    def initialize(args)
      @type = args[:type]
      @name = args[:name]
      @href = args[:href]
      @id = args[:id]
      
      @vdc_links = args[:vdc_links]
      @catalog_links = args[:catalog_links]
      @org_network_links = args[:org_network_links]
    end

    def self.from_reference(ref, session=current_session)
      url = ref.href 
      
      #TODO: verify_ssl proper for prod
      request = RestClient::Request.new(
        :url => url,
        :method => 'get',
        :verify_ssl => false,
        :headers => session.token.merge({ :accept => VCloud::Constants::ContentType::ORG+';version=#{session.api_version}' })
      )

      response = request.execute
      
      vdc_links = []
      catalog_links = []
      org_network_links = []
      
      parsed_xml = parse_xml(response.body)
      
      parsed_xml[:links].each do |link|
        case link.type
        when VCloud::Constants::ContentType::VDC
          vdc_links << link
        when VCloud::Constants::ContentType::CATALOG
          catalog_links << link
        when VCloud::Constants::ContentType::ORG_NETWORK
          org_network_links << link
        end
      end
      
      type =  parsed_xml[:doc].children.first["type"]
      name = parsed_xml[:doc].children.first["name"]
      href = parsed_xml[:doc].children.first["href"]
      id = parsed_xml[:doc].children.first["id"]
                  
      #TODO: Pull this from the XML
      Org.new({:type => type, :name => name, :href => href, :id => id, :vdc_links => vdc_links, :catalog_links => catalog_links, :org_network_links => org_network_links})     
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
  end
end