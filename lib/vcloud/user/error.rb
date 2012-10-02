module VCloud
  class Error
    include HappyMapper
    
    attribute :message,                     String
    attribute :major_error_code,            Integer,  :tag => "majorErrorCode"
    attribute :minor_error_code,            String,   :tag => "minorErrorCode"
    attribute :vendor_specific_error_code,  String,   :tag => "vendorSpecificErrorCode"
    attribute :stack_trace,                 String,   :tag => "stackTrace"
  end
end