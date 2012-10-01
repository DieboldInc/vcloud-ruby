module VCloud
  
  # An org contains links to VDCs, Catalogs, and Org Networks
  class Org < BaseVCloudEntity
    
    has_type VCloud::Constants::ContentType::ORG
    tag 'Org'
    has_links
    has_default_attributes
    element :description, String, :tag => "Description"
    element :full_name, String, :tag => "FullName"
    
    # Returns all links to VDCs
    #
    # @return [Array<VCloud::Link>] Array of Links to VDCs  
    def vdc_links
      @links.select {|l| l.type == VCloud::Constants::ContentType::VDC}
    end
    
    # Returns all links to Catalogs
    #
    # @return [Array<VCloud::Link>] Array of Links to Catalogs
    def catalog_links
      @links.select {|l| l.type == VCloud::Constants::ContentType::CATALOG}
    end

    # Returns all links to OrgNetworks
    #
    # @return [Array<VCloud::Link>] Array of Links to OrgNetworks
    def org_network_links
      @links.select {|l| l.type == VCloud::Constants::ContentType::ORG_NETWORK}
    end
    
    # Returns a hash of of all Catalog links keyed by the Catalog name
    #
    # @return [Hash{String => VCloud::Link}] Links to all Catalogs in the Org, keyed by name
    def get_catalog_links_by_name
      Hash[catalog_links.collect { |l| [l.name, l] }]
    end
    
    # Retrieves an Catalog, assuming the user has access to it
    #
    # @param [String] name Catalog name
    # @param [VCloud::Client] session Session to use to retrieve the Catalog
    # @return [VCloud::Catalog] Catalog object
    def get_catalog_from_name(name, session = self.session)
      catalogs = get_catalog_links_by_name
      link = catalogs[name] or return nil
      Catalog.from_reference(link, session)
    end
    
    # Returns a hash of of all VDCs links keyed by the Catalog name
    #
    # @return [Hash{String => VCloud::Link}] Links to all VDCs in the Org, keyed by name
    def get_vdc_links_by_name
      Hash[vdc_links.collect { |l| [l.name, l] }]
    end
    
    # Retrieves a VDC, assuming the user has access to it
    #
    # @param [String] name VDC name
    # @param [VCloud::Client] session Session to use to retrieve the VDC
    # @return [VCloud::Vdc] VDC object
    def get_vdc_from_name(name, session = self.session)
      links = get_vdc_links_by_name
      link = links[name] or return nil
      Vdc.from_reference(link, session)
    end    
  end
end