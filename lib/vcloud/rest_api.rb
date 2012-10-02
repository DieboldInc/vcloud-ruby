module VCloud
  module RestApi

    def refresh(session = self.session)
      http_opts = build_generic_http_opts(@href, nil, nil, session, {})
      http_opts.merge!(:method => 'get')
      http_opts[:headers][:accept] = self.class.type+";version=#{session.api_version}"
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
      request = RestClient::Request.new(http_opts)    
      response = request.execute { |response, request|
        case response.code
        when 200, 201, 202, 204 then
          return response.body
        when 303 then
          # 303 See Other, provides a Location header
          # TODO: How do we handle this?
          return response.body
        when 400, 401, 403, 404, 405 then
          if response.body.empty?
            major_error_code = response.code
            short_message = VCloud::Exception::HTTPMessage[response.code][:short_message]
            long_message = VCloud::Exception::HTTPMessage[response.code][:message]          
            message = "#{short_message} - #{long_message}"
          
            raise VCloud::VCloudException.new(message, major_error_code)
          else
            error = VCloud::Error.from_xml(response.body)
            raise VCloud::VCloudException.new(error.message, error.major_error_code, error.minor_error_code, error.vendor_specific_error_code, error.stack_trace)
          end
        when 500, 501, 503 then
           if response.body.empty?
              major_error_code = response.code
              short_message = VCloud::Exception::HTTPMessage[response.code][:short_message]
              long_message = VCloud::Exception::HTTPMessage[response.code][:message]          
              message = "#{short_message} - #{long_message}"

              raise VCloud::VCloudException.new(message, major_error_code)
            else
              error = VCloud::Error.from_xml(response.body)
              raise VCloud::VCloudException.new(error.message, error.major_error_code, error.minor_error_code, error.vendor_specific_error_code, error.stack_trace)
            end
        else
          raise Exception
        end
      }
         
      response.nil? ? '' : response.body
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