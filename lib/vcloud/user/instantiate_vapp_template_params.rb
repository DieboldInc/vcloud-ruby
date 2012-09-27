module VCloud
  class InstantiateVAppTemplateParams
    include ParsesXml

    register_namespace 'xmlns', VCloud::Constants::NameSpace::V1_5
    tag 'InstantiateVAppTemplateParams'
    attribute :name, String
    attribute :deploy, Boolean, :state_when_nil => true
    attribute :power_on, Boolean, :tag => 'powerOn'
    element :description, String, :tag => 'Description'
    wrap 'InstantiationParams' do
      has_one :network_config_section, 'VCloud::NetworkConfigSection', :tag => 'NetworkConfigSection'
    end
    element :source_reference, 'VCloud::Reference', :tag => 'Source'
    element :is_source_delete, Boolean, :tag => 'IsSourceDelete'
    element :all_eulas_accepted, Boolean, :tag => 'AllEULAsAccepted'
    
    def initialize
      @name = ''
      @deploy = true
      @power_on = false
      @description = ''
      @all_eulas_accepted = false
      @is_source_delete = false
    end
  end
end