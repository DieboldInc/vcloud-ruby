module VCloud
  class Catalog
    include ParsesXml

    attr_reader :name, :id, :type, :href, :catalog_items
    
    def initialize(args)
      @name = args[:name]
      @id = args[:id]
      @type = args[:type]
      @href = args[:href]
      
      @catalog_items = []
    end
    
    def self.from_reference(ref, session=@current_session)
      url = ref.href 
      
      #TODO: verify_ssl proper for prod
      request = RestClient::Request.new(
        :url => url,
        :method => 'get',
        :verify_ssl => false,
        :headers => session.token.merge({ :accept => VCloud::Constants::ContentType::Catalog+';version=#{session.api_version}' })
      )

      response = request.execute
      puts response
    end
  end
end