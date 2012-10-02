module VCloud
  # Represents an asynchronous operation in vCloud Director
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

    # Wait until the status of the task is set to indicate that the task has completed
    #
    # @param [Integer] timeout Timeout in seconds
    # @yield Block to run upon completion or the timeout is reached, whichever comes first
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

    # Task status as it's being processed
    module Status
      # The task has been queued for execution
      QUEUED      = 'queued'
      # The task is awaiting preprocessing or administrative action
      PRE_RUNNING = 'preRunning'
      # The task is running
      RUNNING     = 'running'
      # The task completed with a status of success
      SUCCESS     = 'success'
      # The task encountered an error while running
      ERROR       = 'error'
      # The task was canceled by the owner or an administrator
      CANCELED    = 'canceled'
      # The task was aborted by an administrative action
      ABORTED     = 'aborted'    
    end
    @@completed_statuses = [Status::SUCCESS, Status::ERROR, Status::CANCELED, Status::ABORTED]

  end
end