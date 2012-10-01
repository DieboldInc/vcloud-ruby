module VCloud
  # Represents the user view of an organization vDC
  class Vdc < BaseVCloudEntity
    include ParsesXml
    
    has_type VCloud::Constants::ContentType::VDC
    tag 'Vdc'
    has_default_attributes
    has_links
    has_many :network_references, 'VCloud::Reference', :tag => 'Network'
    
    # Returns a hash of of all Network references, keyed by the name
    #
    # @return [Hash{String => VCloud::Reference}] Reference to all Networks in the vDC, keyed by name
    def get_network_refs_by_name      
      Hash[@network_references.collect{ |i| [i.name, i] }]
    end
    
    # Create a vApp from a vApp template
    #
    # @param [VCloud::InstantiateVAppTemplateParams] instantiate_vapp_template_params vApp template params
    # @param [VCloud::Client] session Session to create the vApp Template under
    # @return [VCloud::VApp] vApp that was created
    def instantiate_vapp_template(instantiate_vapp_template_params, session = self.session)
      url = @links.select{ |l| l.type == VCloud::Constants::ContentType::INSTANTIATE_VAPP_TEMPLATE_PARAMS }.first.href
      response = post(url, instantiate_vapp_template_params.to_xml, VCloud::Constants::ContentType::INSTANTIATE_VAPP_TEMPLATE_PARAMS, session)
      vapp = VCloud::VApp.new :session => session      
      vapp.parse_xml(response)
      vapp
    end
  end
end