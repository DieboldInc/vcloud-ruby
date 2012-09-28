module VCloud
  class Vdc < BaseVCloudEntity
    include ParsesXml
    
    has_type VCloud::Constants::ContentType::VDC
    tag 'Vdc'
    has_default_attributes
    has_links
    has_many :network_references, 'VCloud::Reference', :tag => 'Network'
    
    def get_network_refs_by_name      
      Hash[@network_references.collect{ |i| [i.name, i] }]
    end
    
    def instantiate_vapp_template(instantiate_vapp_template_params, session = self.session)
      url = @links.select{ |l| l.type == VCloud::Constants::ContentType::INSTANTIATE_VAPP_TEMPLATE_PARAMS }.first.href
      response = post(url, instantiate_vapp_template_params.to_xml, VCloud::Constants::ContentType::INSTANTIATE_VAPP_TEMPLATE_PARAMS, session)
      return VCloud::VApp.parse(response)
    end
  end
end