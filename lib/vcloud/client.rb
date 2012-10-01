module VCloud
  
  # Handles creating and managing a system in vCloud Director.
  
  class Client < BaseVCloudEntity    
    
    tag 'Session'
    has_links
    attribute :type, String
    attribute :href, String
    attribute :user, String
    attribute :org, String
    
    LOGIN = 'login'
    SESSION = 'sessions'
    LOGOUT_SESSION = 'session'
    LOGOUT_HTTP_RESPONSE = 204
    TOKEN = 'x_vcloud_authorization'.to_sym

    attr_reader :api_version, :url, :token

    # Create a new client
    #
    # @param [String] url API endpoint URL
    # @param [VCloud::Constants::Version] api_version API version
    def initialize(url, api_version) 
      @links=[]
      @url = url
      @api_version = api_version
      @token = {}
      @logged_in = false
    end

    # Create a new session and retrieves the session token
    #
    # @param [String] username Username to log in with
    # @param [String] password Password to log in with
    # @return [Boolean] True if a session token has been generated
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
      OrgList.from_reference(get_orglist_link, self).orgs
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
    
    # Destroy the current session
    #
    # @return [Boolean] True if the session was destroyed, false if it could not be destroyed or a session does not exist
    def logout
      return false if not logged_in?
      
      url = @api_version > VCloud::Constants::Version::V0_9 ? @url + LOGOUT_SESSION : @url + LOGIN

      #TODO: verify_ssl proper for prod
      request = RestClient::Request.new(
        :url => url,
        :method => 'delete',
        :verify_ssl => false,
        :headers => token)
      
      response = request.execute      
      response.code == LOGOUT_HTTP_RESPONSE ? true : false
    end
  end
end