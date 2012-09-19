module VCloud
  class Vdc < BaseVCloudEntity
    include ParsesXml
    
    has_type VCloud::Constants::ContentType::VDC
    has_default_attributes
    has_links
    has_reference :network_references, VCloud::Constants::Xpath::NETWORK_REFERENCE
    
    def get_network_refs_by_name
      refs_by_name = {}
      @network_references.each do |item|
        refs_by_name[item.name] = item
      end
      return refs_by_name
    end
    
    def instantiate_vapp_template(instantiate_vapp_template_params, session = current_session)
      url = @links.select {|l| l.type == VCloud::Constants::ContentType::INSTANTIATE_VAPP_TEMPLATE_PARAMS }.first.href
      response = post(url, instantiate_vapp_template_params.to_xml, VCloud::Constants::ContentType::INSTANTIATE_VAPP_TEMPLATE_PARAMS, session)      
    end
  end
end