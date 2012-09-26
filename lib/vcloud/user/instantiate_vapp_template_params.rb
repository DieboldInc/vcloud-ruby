module VCloud
  class InstantiateVAppTemplateParams
    include ParsesXml

    tag 'InstantiateVAppTemplateParams'
    attribute :name, String
    attribute :deploy, Boolean
    attribute :power_on, Boolean, :tag => 'powerOn'
    element :description, String, :tag => 'Description'
    element :source, 'VCloud::Reference', :tag => 'Source'
    element :is_delete_source, Boolean, :tag => 'IsSourceDelete'
    element :all_eulas_accepted, Boolean, :tag => 'AllEULAsAccepted'
    register_namespace 'xmlns', 'http://www.vmware.com/vcloud/v1.5'
    
    attr_reader :instantiation_param_items

    def initialize
      @instantiation_param_items = []
      @deploy = true
      @power_on = false
      @all_eulas_accepted = false
      @is_delete_source = false
    end
  end
end