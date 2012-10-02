module VCloud
  # Represents vApp template instantiation parameters
  class InstantiateVAppTemplateParams
    include ParsesXml

    register_namespace 'xmlns', VCloud::Constants::NameSpace::V1_5
    tag 'InstantiateVAppTemplateParams'
    attribute :name,        String
    attribute :deploy,      Boolean
    attribute :power_on,    Boolean,  :tag => 'powerOn'
    element   :description, String,   :tag => 'Description'
    wrap 'InstantiationParams' do
      has_one :network_config_section, 'VCloud::NetworkConfigSection', :tag => 'NetworkConfigSection'
    end
    element :source_reference,    'VCloud::Reference',  :tag => 'Source'
    element :is_source_delete,    Boolean,              :tag => 'IsSourceDelete'
    element :all_eulas_accepted,  Boolean,              :tag => 'AllEULAsAccepted'
    
    # A new instance of InstantiateVAppTemplateParams
    #
    # @param [String] name Name of the vApp
    # @param [Boolean] deploy True if the vApp should be deployed at instantiation. Defaults to true.
    # @param [Boolean] power_on True if the vApp should be powered-on at instantiation. Defaults to true.
    # @param [String] description Description of the vApp
    # @param [Boolean] all_eulas_accepted True confirms acceptance of all EULAs in a vApp template. Instantiation fails if this element is missing, empty, or set to false and one or more EulaSection elements are present.
    # @param [Boolean] is_source_delete Set to true to delete the source object after the operation completes.
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