module VCloud
  # A vApp is a collection of VMs, network config, etc.
  class VApp < BaseVCloudEntity
    include ParsesXml

    has_type VCloud::Constants::ContentType::VAPP
    tag 'VApp'
    has_links
    has_default_attributes
    has_many :tasks, 'VCloud::Task'

    # Power on all VMs iin the vApp. This operation is available only for a vApp that is powered off.
    #
    # @return [VCloud::Task] Task used to monitor the power on event
    def power_on
      link = links.select{ |l| l.rel == "power:powerOn" }.first
      post_task(link) 
    end

    # def power_off
    #   link = links.select{ |l| l.rel == "power:powerOff" }.first
    #   post_task(link)       
    # end
    # 
    # def suspend
    #   link = links.select{ |l| l.rel == "power:suspend" }.first
    #   post_task(link)  
    # end 
    
    # Delete the vApp
    #
    # @return [VCloud::Task] Task used to monitor the delete vApp event
    def remove
      link = links.select{ |l| l.rel == "remove" }.first
      result = delete(link.href, nil, VCloud::Constants::ACCEPT_HEADER)
      task = VCloud::Task.from_xml(result)
      task.session = session
      task
    end

    # def deploy
    #   link = links.select{ |l| l.rel == "deploy" }.first
    #   post_task(link)
    # end   
    
    # Undeployment deallocates all resources used by the vApp and the VMs it contains
    #
    # @param [VCloud::VApp::UndeployPowerAction] power_action
    # @return [VCloud::Task] Task used to monitor the undeploy vApp event
    def undeploy(power_action)             
      undeploy_params = UndeployVAppParams.new
      undeploy_params.undeploy_power_action = power_action

      link = links.select{ |l| l.rel == "undeploy" }.first

      result = post(link.href, undeploy_params.to_xml, VCloud::Constants::ContentType::UNDEPLOY_VAPP_PARAMS) 
  
      task = VCloud::Task.from_xml(result)
      task.session = self.session
      task
    end  
    
    def parse_xml(xml)
      super xml
      if self.session
        self.tasks.each do |task|
          task.session = self.session
        end
      end
    end

    def post_task(link)
      result = post(link.href, nil, VCloud::Constants::ACCEPT_HEADER)
      task = VCloud::Task.from_xml(result)
      task.session = self.session       
      task  
    end
    
    # The specified action is applied to all VMs in the vApp. 
    # All values other than 'default' ignore actions, order, and delay specified in the StartupSection.
    module UndeployPowerAction
      # Power off the VMs. This is the default action if this attribute is missing or empty)     
      POWER_OFF = 'powerOff'
      # Suspend the VMs
      SUSPEND   = 'suspend' 
      # Shut down the VMs  
      SHUTDOWN  = 'shutdown'
      # Attempt to power off the VMs. Failures in undeploying the VM or associated networks are ignored. All references to the vApp and its VMs are removed from the database
      FORCE     = 'force'
      # Use the actions, order, and delay specified in the StartupSection
      DEFAULT   = 'default'
    end

  end
  
  # Paramater passed when undeploying a VApp
  class UndeployVAppParams
    include HappyMapper
    register_namespace 'xmlns', VCloud::Constants::NameSpace::V1_5
    tag 'UndeployVAppParams'
    element :undeploy_power_action, String, :tag => 'UndeployPowerAction'    
  end
end