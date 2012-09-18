module VCloud
  module Constants
    
    module Version
      V0_9 = '0.9' 
      V1_5 = '1.5'
      V5_1 = '5.1'
    end    

    ACCEPT_HEADER = 'application/*+xml'
    
    module ContentType
      ORG_LIST = 'application/vnd.vmware.vcloud.orgList+xml'
      ORG = 'application/vnd.vmware.vcloud.org+xml'
      VDC = 'application/vnd.vmware.vcloud.vdc+xml'
      CATALOG = 'application/vnd.vmware.vcloud.catalog+xml'
      CATALOG_ITEM = 'application/vnd.vmware.vcloud.catalogItem+xml'
      ORG_NETWORK = 'application/vnd.vmware.vcloud.orgNetwork+xml'
      VAPP_TEMPLATE = 'application/vnd.vmware.vcloud.vAppTemplate+xml' 
    end
    
    module Xpath
      LINK = '//xmlns:Link'
      ORG_REFERENCE = '//xmlns:Org'
      CATALOG_REFERENCE = '//xmlns::Catalog'
      CATALOG_ITEM_REFERENCE = '//xmlns:CatalogItem'
      ENTITY_REFERENCE = '//xmlns:Entity'
    end

  end
end