module VCloud
  class Org < BaseVCloudEntity
    include ParsesXml
    
    has_type VCloud::Constants::ContentType::ORG
    tag 'Org'
    has_links
    has_default_attributes
    
    def vdc_links
      @links.select {|l| l.type == VCloud::Constants::ContentType::VDC}
    end

    def catalog_links
      @links.select {|l| l.type == VCloud::Constants::ContentType::CATALOG}
    end

    def org_network_links
      @links.select {|l| l.type == VCloud::Constants::ContentType::ORG_NETWORK}
    end
    
    def get_catalog_links_by_name()
      catalog_refs = {}
      catalog_links.each do |catalog_link|
        catalog_refs[catalog_link.name] = catalog_link
      end
      catalog_refs
    end
    
    def get_catalog_from_name(name)
      catalogs = get_catalog_links_by_name
      link = catalogs[name]
      Catalog.from_reference(link)
    end
    
    def get_vdc_links_by_name()
      refs = {}
      vdc_links.each do |link|
        refs[link.name] = link
      end
      refs
    end
    
    def get_vdc_from_name(name)
      links = get_vdc_links_by_name
      link = links[name]
      Vdc.from_reference(link)
    end    
  end
end