module VCloud
  class Client
    include ParsesXml

    has_links
    has_reference :org, VCloud::Constants::Xpath::ORG_REFERENCE

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
      @links = Client.parse_xml(response.body)[:links]
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
        :url => get_orglist_link.href,
        :method => 'get',
        :verify_ssl => false,
        :headers => @token.merge({:accept => VCloud::Constants::ContentType::ORG_LIST+';version=#{@api_version}'}))
      response = request.execute      
      Client.parse_xml(response.body)[:org]
    end
  
    def get_org_from_name(name)
      orgs = get_org_refs_by_name
      ref = orgs[name]
      org = Org.from_reference(ref, self)
      return org
    end
    
    def get_orglist_link
      @orglist ||= @links.select {|l| l.type == VCloud::Constants::ContentType::ORG_LIST}.first
    end

  end
end