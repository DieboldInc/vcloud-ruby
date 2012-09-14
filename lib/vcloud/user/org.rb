module VCloud
  class Org

    attr_reader :type, :name, :href, :vdcs, :catalogs, :networks

    def initialize(args)
      @type = args[:type]
      @name = args[:name]
      @href = args[:href]
      
      @vdcs = []
      @catalogs = []
      @networks = []

    end

    def self.FromXML(org_xml)
      doc = XmlSimple.xml_in(org_xml)
      new(
      type: doc['type'], 
      name: doc['name'], 
      href: doc['href'])
    end

    def self.FromReference(ref, session=current_session)
      url = ref.href 
      puts session.inspect

      #TODO: verify_ssl proper for prod
      request = RestClient::Request.new(
        :url => url,
        :method => 'get',
        :verify_ssl => false,
        :headers => session.token.merge({ :accept => VCloud::Constants::ContentType::ORG+';version=#{session.api_version}' })
      )

      puts request.headers

      response = request.execute      
      puts response
    end
  end
end