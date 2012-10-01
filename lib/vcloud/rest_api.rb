module VCloud
  module RestApi

    def refresh(session = self.session)
      #TODO: verify_ssl proper for prod
      request = RestClient::Request.new(
        :url => @href,
        :method => 'get',
        :verify_ssl => false,
        :headers => session.token.merge({ :accept => self.class.type+";version=#{session.api_version}" })
      )
      response = request.execute
      parse_response(response)
    end
          
    def create
    end
    
    def update
    end
    
    def delete(url, payload, content_type, session = self.session)
      #TODO: verify_ssl proper for prod
      request = RestClient::Request.new(
        :url => url,
        :method => 'delete',
        :payload => payload,
        :verify_ssl => false,
        :headers => session.token.merge({
          :accept => VCloud::Constants::ACCEPT_HEADER+";version=#{session.api_version}",
          :content_type => content_type})
      )

      response = request.execute
      return response.body      
    end
    
    def post (url, payload, content_type, session = self.session)
      #TODO: verify_ssl proper for prod
      request = RestClient::Request.new(
        :url => url,
        :method => 'post',
        :payload => payload,
        :verify_ssl => false,
        :headers => session.token.merge({
          :accept => VCloud::Constants::ACCEPT_HEADER+";version=#{session.api_version}",
          :content_type => content_type})
      )

      response = request.execute
      return response.body
    end    

    #override to provide custom parsing
    def parse_response(response)
      parse_xml(response.body)
    end
    
  end
end