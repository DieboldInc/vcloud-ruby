module VCloud
  class Client < BaseVCloudEntity    
    
    tag 'Session'
    has_links
    attribute :type, String
    attribute :href, String
    attribute :user, String
    attribute :org, String
    
    LOGIN = 'login'
    SESSION = 'sessions'
    TOKEN = 'x_vcloud_authorization'.to_sym

    attr_reader :api_version, :url, :token

    def initialize(url, api_version) 
      @links=[]
      @url = url
      @api_version = api_version
      @token = {}
      @logged_in = false
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
        :headers => { :accept => VCloud::Constants::ACCEPT_HEADER+";version=#{@api_version}" })
      response = request.execute
      parse_xml(response.body)

      @token = { TOKEN => response.headers[TOKEN] }      
      @logged_in = true
            
      return true
    end
  
    def get_org_refs_by_name()
      Hash[get_org_refs.collect{ |i| [i.name, i] }]
    end
  
    def get_org_refs()
      OrgList.from_reference(get_orglist_link).orgs
    end
  
    def get_org_from_name(name)
      orgs = get_org_refs_by_name
      ref = orgs[name] or return nil
      org = Org.from_reference(ref, self)
      return org
    end
    
    def get_orglist_link
      @orglist ||= @links.select {|l| l.type == VCloud::Constants::ContentType::ORG_LIST}.first
    end
    
    def logged_in?
      @logged_in
    end
  end
end