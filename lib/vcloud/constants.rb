module VCloud
  module Constants
    
    module Version
      V0_9 = '0.9' 
      V1_5 = '1.5'
      V5_1 = '5.1'
    end    

    ACCEPT_HEADER = 'application/*+xml'
    XML_ENCODING = 'UTF-8'
    
    module ContentType
      ORG_LIST = 'application/vnd.vmware.vcloud.orgList+xml'
      ORG = 'application/vnd.vmware.vcloud.org+xml'
      VDC = 'application/vnd.vmware.vcloud.vdc+xml'
      CATALOG = 'application/vnd.vmware.vcloud.catalog+xml'
      CATALOG_ITEM = 'application/vnd.vmware.vcloud.catalogItem+xml'
      ORG_NETWORK = 'application/vnd.vmware.vcloud.orgNetwork+xml'
      VAPP_TEMPLATE = 'application/vnd.vmware.vcloud.vAppTemplate+xml'
      NETWORK_CONFIG_SECTION = 'application/vnd.vmware.vcloud.networkConfigSection+xml'
      INSTANTIATE_VAPP_TEMPLATE_PARAMS = 'application/vnd.vmware.vcloud.instantiateVAppTemplateParams+xml'
    end
    
    module Xpath
      LINK = '//xmlns:Link'
      ORG_REFERENCE = '//xmlns:Org'
      CATALOG_REFERENCE = '//xmlns::Catalog'
      CATALOG_ITEM_REFERENCE = '//xmlns:CatalogItem'
      ENTITY_REFERENCE = '//xmlns:Entity'
      NETWORK_REFERENCE = '//xmlns:Network'
    end
    
    module NameSpace
      V1_5 = 'http://www.vmware.com/vcloud/v1.5'
      OVF = 'http://schemas.dmtf.org/ovf/envelope/1'
      XSI = 'http://www.w3.org/2001/XMLSchema-instance'
    end      

  end
end