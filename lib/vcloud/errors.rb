module VCloud
  module Errors
    HTTPMessage = {
        200 => {:short_message => 'OK', :message => 'The request is valid and was completed. The response includes a document body.'},
        201 => {:short_message => 'Created', :message => 'The request is valid. The requested object was created and can be found at the URL specified in the Location header.'},
        202 => {:short_message => 'Accepted', :message => 'The request is valid and a task was created to handle it. This response is usually accompanied by a Task element.'},
        204 => {:short_message => 'No Content', :message => 'The request is valid and was completed. The response does not include a body.'},
        303 => {:short_message => 'See Other', :message => 'The response to the request can be found at the URL specified in the Location header.'},
        400 => {:short_message => 'Bad Request', :message => 'The request body is malformed, incomplete, or otherwise invalid.'},
        401 => {:short_message => 'Unauthorized', :message => 'An authorization header was expected but not found.'},
        403 => {:short_message => 'Forbidden', :message => 'The requesting user does not have adequate privileges to access one or more objects specified in the request.'},
        404 => {:short_message => 'Not Found', :message => 'One or more objects specified in the request could not be found in the specified container.'},
        405 => {:short_message => 'Method Not Allowed', :message => 'The HTTP method specified in the request is not supported for this object.'},
        500 => {:short_message => 'Internal Server Error', :message => 'The request was received but could not be completed because of an internal error at the server.'},
        501 => {:short_message => 'Not Implemented', :message => 'The server does not implement the request.'},
        503 => {:short_message => 'Service Unavailable', :message => 'One or more services needed to complete the request are not available on the server.'}
      }
  end

  class VCloudError < StandardError
    attr_reader :message, :major_error_code, :minor_error_code, :vendor_specific_error_code, :stack_trace

    def initialize(message, major_error_code, minor_error_code = nil, vendor_specific_error_code = nil, stack_trace = nil)
      @message                    = message
      @major_error_code           = major_error_code
      @minor_error_code           = minor_error_code
      @vendor_specific_error_code = vendor_specific_error_code
      @stack_trace                = stack_trace
    end
  end
end