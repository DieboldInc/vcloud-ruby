module VCloud
  # A vApp is a collection of VMs, network config, etc.
  class VApp < BaseVCloudEntity
    include ParsesXml

    has_type VCloud::Constants::ContentType::VAPP
    tag 'VApp'
    has_links
    has_default_attributes
    has_many :tasks, 'VCloud::Task'

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
    
    module UndeployPowerAction
      # The specified action is applied to all VMs in the vApp. 
      # All values other than 'default' ignore actions, order, and delay specified in the StartupSection.     
      POWER_OFF = 'powerOff'  # Power off the VMs. This is the default action if this attribute is missing or empty)
      SUSPEND   = 'suspend'   # Suspend the VMs
      SHUTDOWN  = 'shutdown'  # Shut down the VMs
      FORCE     = 'force'     # Attempt to power off the VMs. Failures in undeploying the VM or associated networks are ignored. All references to the vApp and its VMs are removed from the database
      DEFAULT   = 'default'   # Use the actions, order, and delay specified in the StartupSection
    end

  end
  
  class UndeployVAppParams
    include HappyMapper
    register_namespace 'xmlns', VCloud::Constants::NameSpace::V1_5
    tag 'UndeployVAppParams'
    element :undeploy_power_action, String, :tag => 'UndeployPowerAction'    
  end
end