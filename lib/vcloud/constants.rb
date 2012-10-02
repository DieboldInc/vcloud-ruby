module VCloud
  module Constants
    
    # vCloud Director API versions
    module Version
      V0_9 = '0.9' 
      V1_5 = '1.5'
      V5_1 = '5.1'
    end    

    ACCEPT_HEADER = 'application/*+xml'
    XML_ENCODING = 'UTF-8'
    
    # vCloud Director MIME types
    module ContentType
      CATALOG                          = 'application/vnd.vmware.vcloud.catalog+xml'
      CATALOG_ITEM                     = 'application/vnd.vmware.vcloud.catalogItem+xml'
      INSTANTIATE_VAPP_TEMPLATE_PARAMS = 'application/vnd.vmware.vcloud.instantiateVAppTemplateParams+xml'
      NETWORK_CONFIG_SECTION           = 'application/vnd.vmware.vcloud.networkConfigSection+xml'
      ORG                              = 'application/vnd.vmware.vcloud.org+xml'
      ORG_LIST                         = 'application/vnd.vmware.vcloud.orgList+xml'      
      ORG_NETWORK                      = 'application/vnd.vmware.vcloud.orgNetwork+xml'
      TASK                             = 'application/vnd.vmware.vcloud.task+xml'
      UNDEPLOY_VAPP_PARAMS             = 'application/vnd.vmware.vcloud.undeployVAppParams+xml'  
      VAPP                             = 'application/vnd.vmware.vcloud.vApp+xml'
      VAPP_TEMPLATE                    = 'application/vnd.vmware.vcloud.vAppTemplate+xml'
      VDC                              = 'application/vnd.vmware.vcloud.vdc+xml'
    end
    
    # vCloud Director API XML namespaces
    module NameSpace
      V1_5 = 'http://www.vmware.com/vcloud/v1.5'
      OVF = 'http://schemas.dmtf.org/ovf/envelope/1'
      XSI = 'http://www.w3.org/2001/XMLSchema-instance'
    end      

  end
end