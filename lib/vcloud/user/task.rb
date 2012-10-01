module VCloud
  # Represents an asynchronous operation in vCloud Director
  class Task < BaseVCloudEntity
    include ParsesXml
    
    has_type VCloud::Constants::ContentType::TASK
    tag 'Task'
    has_links
    has_default_attributes
    attribute :status, String
    attribute :start_time, String, :tag => 'startTime' 
    attribute :operation_name, String, :tag => 'operationName'
    attribute :operation, String
    attribute :expiry_time, String, :tag => 'expiryTime'
  end
end