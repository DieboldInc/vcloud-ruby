module VCloud
  module RestApi

    def refresh(session = self.session)
      http_opts = build_generic_http_opts(@href, nil, nil, session, {})
      http_opts.merge!(:method => 'get')
      http_opts[:headers][:accept] = self.class.type
      response = http_request(http_opts)
      parse_response(response)
    end
          
    def create
    end
    
    def update
    end
    
    def delete(url, payload, content_type, session = self.session, opts={})
      http_opts = build_generic_http_opts(url, payload, content_type, session, opts)
      http_opts.merge!(:method => 'delete')
      http_request(http_opts)     
    end
    
    def post(url, payload, content_type, session = self.session, opts={})
      http_opts = build_generic_http_opts(url, payload, content_type, session, opts)
      http_opts.merge!(:method => 'post')
      http_request(http_opts)
    end    

    def http_request(http_opts)
      begin
        request = RestClient::Request.new(http_opts)    
        response = request.execute
      rescue => e
        puts e.inspect
        raise e
      end            
      response.body
    end
   
    def build_generic_http_opts(url, payload, content_type, session, opts)
      headers = {:accept => VCloud::Constants::ACCEPT_HEADER+";version=#{session.api_version}"}.merge(session.token)
      headers.merge!(:content_type => content_type) if content_type
      {
        :url        => url,
        :payload    => payload,
        :verify_ssl => session.verify_ssl,
        :headers    => headers
      }.merge(opts)
    end
    
    #override to provide custom parsing
    def parse_response(response)
      parse_xml(response.body)
    end
    
  end
end