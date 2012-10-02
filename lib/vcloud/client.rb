module VCloud

  # Handles creating and managing a session in vCloud Director.
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
    attr_accessor :verify_ssl

    # Create a new client
    #
    # @param [String] url API endpoint URL
    # @param [VCloud::Constants::Version] api_version API version
    def initialize(url, api_version, opts={}) 
      @links=[]
      @url = url
      @api_version = api_version
      @token = {}
      @logged_in = false
      
      @verify_ssl = opts[:verify_ssl].nil? ? true : opts[:verify_ssl]
    end

    # Create a new session and retrieves the session token
    #
    # @param [String] username Username to log in with
    # @param [String] password Password to log in with
    # @return [Boolean] True if a session token has been generated
    def login(username, password)
      return true if @logged_in

      url = @api_version > VCloud::Constants::Version::V0_9 ? @url + SESSION : @url + LOGIN

      response = post(url, nil, nil, self, :user => username, :password => password)
      parse_xml(response)

      @token = { TOKEN => response.headers[TOKEN] }      
      @logged_in = true
            
      return true
    end
  
    # Returns a hash of of all Org refs keyed by the Org name
    #
    # @return [Hash{String => VCloud::Reference}] Reference to all Orgs the user has access to, keyed by Org name
    def get_org_references_by_name()
      Hash[get_org_refs.collect{ |i| [i.name, i] }]
    end
  
    # Returns an OrgList that contains all of the Orgs the user has access to
    #
    # @return [VCloud::OrgList] OrgList that contains all of the Orgs the user has access to
    def get_org_references()
      OrgList.from_reference(get_orglist_link, self).orgs
    end
    
    # Retrieves an Org, assuming the user has access to it
    #
    # @param [String] name Org name
    # @return [VCloud::Org] Org object
    def get_org_from_name(name)
      orgs = get_org_refs_by_name
      ref = orgs[name] or return nil
      org = Org.from_reference(ref, self)
      return org
    end
    
    # Returns the Link object to retrieve an OrgList
    #
    # @return [VCloud::Link] Link for the OrgList
    def get_orglist_link
      @orglist ||= @links.select {|l| l.type == VCloud::Constants::ContentType::ORG_LIST}.first
    end
    
    # Determins if the user is logged in
    #
    # @return [Boolean] True if the user is logged in, otherwise false
    def logged_in?
      @logged_in
    end
    
    # Destroy the current session
    #
    # @return [Boolean] True if the session was destroyed, false if it could not be destroyed or a session does not exist
    def logout
      return false if not logged_in?
      
      url = @api_version > VCloud::Constants::Version::V0_9 ? @url + LOGOUT_SESSION : @url + LOGIN

      begin
        delete(url, nil, nil, self)
      rescue => e
        return false
      end
      
      @token = nil   
      @logged_in = false
      return true
    end
  end
end