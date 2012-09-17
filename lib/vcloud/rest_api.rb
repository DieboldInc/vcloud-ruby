module VCloud
  module RestApi
    include Session
    
    def refresh (session = current_session)
      #TODO: verify_ssl proper for prod
      request = RestClient::Request.new(
        :url => @href,
        :method => 'get',
        :verify_ssl => false,
        :headers => session.token.merge({ :accept => self.class.type+';version=#{session.api_version}' })
      )
      response = request.execute
      parse_response(response)
    end
          
    def create
    end
    
    def update
    end
    
    def delete      
    end
    
    #override to provide custom parsing
    def parse_response(response)
      parse_xml(response.body)
    end
    
  end
end