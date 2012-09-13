module VCloud

  class Client
    LOGIN = 'login'
    SESSION = 'sessions'
    TOKEN = 'x_vcloud_authorization'.to_sym
      
    attr_reader :api_version, :url, :user, :org, :token
        
    @links = []
    @logged_in = false
        
    def initialize(url, api_version)
      @url = url
      @api_version = api_version
      @user = ''
      @org = ''     
      @token = {}
    end
  
    def login(username, password)
      return true if @logged_in
      
      url = @api_version > VCloud::Constants::Version::V0_9 ? @url + SESSION : @url + LOGIN
      
      #TODO: verify_ssl proper for prod
      request = RestClient::Request.new(
        :url => url,
        :method => 'post',
        :user => username,
        :password => password,
        :verify_ssl => false,
        :headers => { :accept => VCloud::Constants::ACCEPT_HEADER+';version=#{@api_version}' })
      
      response = request.execute
      
      parse_session_links(response.body)
      @token = { TOKEN => response.headers[TOKEN] }      
      @user, @org = username.split('@')
      @logged_in = true
            
      return true
    
  
    end
  
    def get_org_refs_by_name()
      #TODO: update verify ssl for prod
      request = RestClient::Request.new(
        :url = @links.select {|l| l.type == VCloud::Constants::ContentType::ORG_LIST}.first,
        :method = 'get',
        :verify_ssl => false,
        :headers => @token.merge({:accept => VCloud::Constants::ContentType::ORG_LIST}))
      response = request.execute
      doc = Nokogiri::XML(response.body)
      refs = {}
      doc.xpath('//xmlns:Org').each do |elem|
        refs[elem.attr('name')] = elem
      end
      refs    
    end
  
  
    private
    
    def parse_session_links(xml)
      @links = []
      doc = Nokogiri::XML(xml)
      doc.xpath('//xmlns:Link').each { |link| @links << Link.FromXML(link.to_s) }      
    end
  
  end
end