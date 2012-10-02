module VCloud
  class VCloudException < Exception
    attr_reader :message, :major_error_code, :minor_error_code, :vendor_specific_error_code, :stack_trace

    def initialize(message, major_error_code, minor_error_code = nil, vendor_specific_error_code = nil, stack_trace = nil)
      @message                    = message
      @major_error_code           = major_error_code
      @minor_error_code           = minor_error_code
      @vendor_specific_error_code = vendor_specific_error_code
      @stack_trace                = stack_trace
      yield(self) if block_given?
    end
  end
end