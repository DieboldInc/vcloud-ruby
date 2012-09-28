module VCloud
  class Org < BaseVCloudEntity
    
    has_type VCloud::Constants::ContentType::ORG
    tag 'Org'
    has_links
    has_default_attributes
    element :description, String, :tag => "Description"
    element :full_name, String, :tag => "FullName"
    
    def vdc_links
      @links.select {|l| l.type == VCloud::Constants::ContentType::VDC}
    end

    def catalog_links
      @links.select {|l| l.type == VCloud::Constants::ContentType::CATALOG}
    end

    def org_network_links
      @links.select {|l| l.type == VCloud::Constants::ContentType::ORG_NETWORK}
    end
    
    def get_catalog_links_by_name
      Hash[catalog_links.collect { |l| [l.name, l] }]
    end
    
    def get_catalog_from_name(name, session = self.session)
      catalogs = get_catalog_links_by_name
      link = catalogs[name] or return nil
      Catalog.from_reference(link, session)
    end
    
    def get_vdc_links_by_name
      Hash[vdc_links.collect { |l| [l.name, l] }]
    end
    
    def get_vdc_from_name(name, session = self.session)
      links = get_vdc_links_by_name
      link = links[name] or return nil
      Vdc.from_reference(link, session)
    end    
  end
end