module VCloud
  class Task < BaseVCloudEntity
    require 'timeout'
    
    include ParsesXml

    has_type VCloud::Constants::ContentType::TASK
    tag 'Task'
    has_links
    has_default_attributes
    attribute :status,          String
    attribute :start_time,      String, :tag => 'startTime' 
    attribute :operation_name,  String, :tag => 'operationName'
    attribute :operation,       String
    attribute :expiry_time,     String, :tag => 'expiryTime'

    def wait_to_finish(timeout = 60 * 10) 
      first_run = true
      Timeout::timeout(timeout) do        
        until @@completed_statuses.include?(self.status)
          sleep 3 if not first_run
          refresh    
          first_run = false
        end
      end
      yield(self) if block_given?
    end

    module Status
      QUEUED      = 'queued'
      PRE_RUNNING = 'preRunning'
      RUNNING     = 'running'
      SUCCESS     = 'success'
      ERROR       = 'error'
      CANCELED    = 'canceled'
      ABORTED     = 'aborted'    
    end
    @@completed_statuses = [Status::SUCCESS, Status::ERROR, Status::CANCELED, Status::ABORTED]
    
  end
end