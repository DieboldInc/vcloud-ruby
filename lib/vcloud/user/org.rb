module VCloud
  class Org
    include ParsesXml

    attr_reader :type, :name, :href, :vdcs, :catalogs, :networks

    def initialize(args)
      @type = args[:type]
      @name = args[:name]
      @href = args[:href]
      
      @vdcs = []
      @catalogs = []
      @networks = []
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
    
  end
end