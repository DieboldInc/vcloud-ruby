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
  
    def set_as_default_session
      VCloud::Session.set_session(self)
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
      org_refs = get_org_refs
      refs_by_name = {}
      org_refs.each { |ref| refs_by_name[ref.name] = ref }
      refs_by_name
    end
  
    def get_org_refs()
      #TODO: update verify ssl for prod
      request = RestClient::Request.new(
        :url => get_orglist_link.first.href,
        :method => 'get',
        :verify_ssl => false,
        :headers => @token.merge({:accept => VCloud::Constants::ContentType::ORG_LIST}))
      response = request.execute
      response.body
      refs = []
      doc = Nokogiri::XML(response.body)
      doc.xpath('//xmlns:Org').each { |elem| refs << Reference.FromXML(elem) }
      refs
    end
  
    def get_org_from_name(name)
      orgs = get_org_refs_by_name
      ref = orgs[name]
      org = Org.FromReference(ref, self)
      return org
    end
    
    def get_orglist_link
      @orglist ||= @links.select {|l| l.type == VCloud::Constants::ContentType::ORG_LIST}.first
    end
    
    private
    
    def parse_session_links(xml)
      @links = []
      doc = Nokogiri::XML(xml)
      doc.xpath('//xmlns:Link').each { |link| @links << Link.FromXML(link.to_s) }      
    end
  
  end
end