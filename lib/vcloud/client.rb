module VCloud

  class Client
    LOGIN = 'login'
    SESSION = 'sessions'
    TOKEN = 'x_vcloud_authorization'.to_sym
      
    attr_reader :api_version, :url, :user, :org
        
    @links = []
    @token_header = {}
        
    def initialize(url, api_version)
      @url = url
      @api_version = api_version
    end
  
    def login(username, password)
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
      parse_session_xml(response.body)
      @token_header = { TOKEN => response.headers[TOKEN] }
      
      @user, @org = username.split('@')
      return true
    
  
    end
  
    private
    
    def parse_session_xml(xml)
      @links = []
      doc = XmlSimple.xml_in(xml)
      doc['Link'].each { |link| @links << Link.new(link) }      
    end
  
  end
end