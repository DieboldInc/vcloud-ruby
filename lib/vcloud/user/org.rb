module VCloud
  class Org
    include ParsesXml

    attr_reader :type, :name, :href, :vdcs, :catalogs, :networks, :vdc_links, :catalog_links, :org_network_links

    def initialize(args)
      @type = args[:type]
      @name = args[:name]
      @href = args[:href]
      
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
            
      vdc_links = get_vdc_links(response.body)      
      catalog_links = get_catalog_links(response.body)
      org_network_links = get_org_network_links(response.body)
      
      #TODO: Pull this from the XML
      Org.new({:type => VCloud::Constants::ContentType::ORG, :name => "blah", :href => "dah", :vdc_links => vdc_links, :catalog_links => catalog_links, :org_network_links => org_network_links})     
    end
    
    def self.get_vdc_links(xml)
      links = links_from_xml(xml)
      vdcs = []
      links.each do |link|
        if link.type == VCloud::Constants::ContentType::VDC
          vdcs << link
        end
      end

      return vdcs
    end
    
    def self.get_catalog_links(xml)
      links = links_from_xml(xml)
      catalogs = []
      links.each do |link|
        if link.type == VCloud::Constants::ContentType::CATALOG
          catalogs << link
        end
      end

      return catalogs
    end
    
    def self.get_org_network_links(xml)
      links = links_from_xml(xml)
      networks = []
      links.each do |link|
        if link.type == VCloud::Constants::ContentType::ORG_NETWORK
          networks << link
        end
      end

      return networks
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