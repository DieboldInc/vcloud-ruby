require 'webmock/rspec'

require_relative '../lib/vcloud'

module VCloud
  module Test
    module Data
      SESSION_XML  = %q{<?xml version="1.0" encoding="UTF-8"?>
      <Session xmlns="http://www.vmware.com/vcloud/v1.5" user="test" org="someorg" type="application/vnd.vmware.vcloud.session+xml" href="https://some.vcloud.com/api/session/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.vmware.com/vcloud/v1.5 http://127.0.0.1/api/v1.5/schema/master.xsd">
          <Link rel="down" type="application/vnd.vmware.vcloud.orgList+xml" href="https://some.vcloud.com/api/org/"/>
          <Link rel="down" type="application/vnd.vmware.admin.vcloud+xml" href="https://some.vcloud.com/api/admin/"/>
          <Link rel="down" type="application/vnd.vmware.vcloud.query.queryList+xml" href="https://some.vcloud.com/api/query"/>
          <Link rel="entityResolver" type="application/vnd.vmware.vcloud.entity+xml" href="https://some.vcloud.com/api/entity/"/>
      </Session>}
      
      ORG_LIST_XML = %q{<?xml version="1.0" encoding="UTF-8"?>
      <OrgList xmlns="http://www.vmware.com/vcloud/v1.5" type="application/vnd.vmware.vcloud.orgList+xml" href="https://some.vcloud.com/api/org/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.vmware.com/vcloud/v1.5 http://127.0.0.1/api/v1.5/schema/master.xsd">
          <Org type="application/vnd.vmware.vcloud.org+xml" name="someorg" href="https://some.vcloud.com/api/org/aaa-bbb-ccc-ddd-eee-fff"/>
      </OrgList>}
      
      ORG_XML = %q{<?xml version="1.0" encoding="UTF-8"?>
      <Org xmlns="http://www.vmware.com/vcloud/v1.5" name="someorg" id="urn:vcloud:org:aaa-bbb-ccc-ddd-eee-fff" type="application/vnd.vmware.vcloud.org+xml" href="https://some.vcloud.com/api/org/aaa-bbb-ccc-ddd-eee-fff" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.vmware.com/vcloud/v1.5 http://127.0.0.1/api/v1.5/schema/master.xsd">
          <Link rel="down" type="application/vnd.vmware.vcloud.vdc+xml" name="SomeVDC" href="https://some.vcloud.com/api/vdc/aaa-bbb-ccc-ddd-eee-fff"/>
          <Link rel="down" type="application/vnd.vmware.vcloud.tasksList+xml" href="https://some.vcloud.com/api/tasksList/aaa-bbb-ccc-ddd-eee-fff"/>
          <Link rel="down" type="application/vnd.vmware.vcloud.catalog+xml" name="SuperCool Catalog" href="https://some.vcloud.com/api/catalog/aaa-bbb-ccc-ddd-eee-fff"/>
          <Link rel="down" type="application/vnd.vmware.vcloud.controlAccess+xml" href="https://some.vcloud.com/api/org/aaa-bbb-ccc-ddd-eee-fff/catalog/aaa-bbb-ccc-ddd-eee-fff/controlAccess/"/>
          <Link rel="down" type="application/vnd.vmware.vcloud.orgNetwork+xml" name="Dev VLAN" href="https://some.vcloud.com/api/network/aaa-bbb-ccc-ddd-eee-fff"/>
          <Link rel="down" type="application/vnd.vmware.vcloud.metadata+xml" href="https://some.vcloud.com/api/org/aaa-bbb-ccc-ddd-eee-fff/metadata"/>
          <Description>This is an example orginization</Description>
          <FullName>Example Orginization</FullName>
      </Org>}
      
      CATALOG_XML = %q{<?xml version="1.0" encoding="UTF-8"?>
      <Catalog xmlns="http://www.vmware.com/vcloud/v1.5" name="HALP Catalog" id="urn:vcloud:catalog:aaa-bbb-ccc-ddd-eee-fff" type="application/vnd.vmware.vcloud.catalog+xml" href="https://some.vcloud.com/api/catalog/aaa-bbb-ccc-ddd-eee-fff" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.vmware.com/vcloud/v1.5 http://127.0.0.1/api/v1.5/schema/master.xsd">
          <Link rel="down" type="application/vnd.vmware.vcloud.metadata+xml" href="https://some.vcloud.com/api/catalog/aaa-bbb-ccc-ddd-eee-fff/metadata"/>
          <CatalogItems>
              <CatalogItem type="application/vnd.vmware.vcloud.catalogItem+xml" name="Ubuntu 10.04.4 LTS" href="https://some.vcloud.com/api/catalogItem/aaa-bbb-ccc-ddd-eee-fff"/>
          </CatalogItems>
          <IsPublished>true</IsPublished>
      </Catalog>}
      
      CATALOG_ITEM_XML = %q{<?xml version="1.0" encoding="UTF-8"?>
      <CatalogItem xmlns="http://www.vmware.com/vcloud/v1.5" name="Ubuntu 10.04.4 LTS" id="urn:vcloud:catalogitem:aaa-bbb-ccc-ddd-eee-fff" type="application/vnd.vmware.vcloud.catalogItem+xml" href="https://some.vcloud.com/api/catalogItem/aaa-bbb-ccc-ddd-eee-fff" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.vmware.com/vcloud/v1.5 http://127.0.0.1/api/v1.5/schema/master.xsd">
          <Link rel="up" type="application/vnd.vmware.vcloud.catalog+xml" href="https://some.vcloud.com/api/catalog/aaa-bbb-ccc-ddd-eee-fff"/>
          <Link rel="down" type="application/vnd.vmware.vcloud.metadata+xml" href="https://some.vcloud.com/api/catalogItem/aaa-bbb-ccc-ddd-eee-fff/metadata"/>
          <Entity type="application/vnd.vmware.vcloud.vAppTemplate+xml" name="Ubuntu 10.04.4 LTS" href="https://some.vcloud.com/api/vAppTemplate/vappTemplate-aaa-bbb-ccc-ddd-eee-fff"/>
      </CatalogItem>}
      
      VDC_XML = %q{<?xml version="1.0" encoding="UTF-8"?>
      <Vdc xmlns="http://www.vmware.com/vcloud/v1.5" status="1" name="EmTech" id="urn:vcloud:vdc:aaa-bbb-ccc-ddd-eee-fff" type="application/vnd.vmware.vcloud.vdc+xml" href="https://some.vcloud.com/api/vdc/aaa-bbb-ccc-ddd-eee-fff" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.vmware.com/vcloud/v1.5 http://127.0.0.1/api/v1.5/schema/master.xsd">
          <Link rel="up" type="application/vnd.vmware.vcloud.org+xml" href="https://some.vcloud.com/api/org/aaa-bbb-ccc-ddd-eee-fff"/>
          <Link rel="down" type="application/vnd.vmware.vcloud.metadata+xml" href="https://some.vcloud.com/api/vdc/aaa-bbb-ccc-ddd-eee-fff/metadata"/>
          <Link rel="add" type="application/vnd.vmware.vcloud.uploadVAppTemplateParams+xml" href="https://some.vcloud.com/api/vdc/aaa-bbb-ccc-ddd-eee-fff/action/uploadVAppTemplate"/>
          <Link rel="add" type="application/vnd.vmware.vcloud.media+xml" href="https://some.vcloud.com/api/vdc/aaa-bbb-ccc-ddd-eee-fff/media"/>
          <Link rel="add" type="application/vnd.vmware.vcloud.instantiateVAppTemplateParams+xml" href="https://some.vcloud.com/api/vdc/aaa-bbb-ccc-ddd-eee-fff/action/instantiateVAppTemplate"/>
          <Link rel="add" type="application/vnd.vmware.vcloud.cloneVAppParams+xml" href="https://some.vcloud.com/api/vdc/aaa-bbb-ccc-ddd-eee-fff/action/cloneVApp"/>
          <Link rel="add" type="application/vnd.vmware.vcloud.cloneVAppTemplateParams+xml" href="https://some.vcloud.com/api/vdc/aaa-bbb-ccc-ddd-eee-fff/action/cloneVAppTemplate"/>
          <Link rel="add" type="application/vnd.vmware.vcloud.cloneMediaParams+xml" href="https://some.vcloud.com/api/vdc/aaa-bbb-ccc-ddd-eee-fff/action/cloneMedia"/>
          <Link rel="add" type="application/vnd.vmware.vcloud.captureVAppParams+xml" href="https://some.vcloud.com/api/vdc/aaa-bbb-ccc-ddd-eee-fff/action/captureVApp"/>
          <Link rel="add" type="application/vnd.vmware.vcloud.composeVAppParams+xml" href="https://some.vcloud.com/api/vdc/aaa-bbb-ccc-ddd-eee-fff/action/composeVApp"/>
          <AllocationModel>AllocationVApp</AllocationModel>
          <StorageCapacity>
              <Units>MB</Units>
              <Allocated>0</Allocated>
              <Limit>0</Limit>
              <Used>17068</Used>
              <Overhead>0</Overhead>
          </StorageCapacity>
          <ComputeCapacity>
              <Cpu>
                  <Units>MHz</Units>
                  <Allocated>0</Allocated>
                  <Limit>0</Limit>
                  <Used>0</Used>
                  <Overhead>0</Overhead>
              </Cpu>
              <Memory>
                  <Units>MB</Units>
                  <Allocated>0</Allocated>
                  <Limit>0</Limit>
                  <Used>0</Used>
                  <Overhead>0</Overhead>
              </Memory>
          </ComputeCapacity>
          <ResourceEntities>
              <ResourceEntity type="application/vnd.vmware.vcloud.vAppTemplate+xml" name="Ubuntu 12.04" href="https://some.vcloud.com/api/vAppTemplate/vappTemplate-aaa-bbb-ccc-ddd-eee-fff"/>
              <ResourceEntity type="application/vnd.vmware.vcloud.media+xml" name="Ubuntu 12.04" href="https://some.vcloud.com/api/media/aaa-bbb-ccc-ddd-eee-fff"/>
          </ResourceEntities>
          <AvailableNetworks>
              <Network type="application/vnd.vmware.vcloud.network+xml" name="Dev VLAN" href="https://some.vcloud.com/api/network/aaa-bbb-ccc-ddd-eee-fff"/>
          </AvailableNetworks>
          <Capabilities>
              <SupportedHardwareVersions>
                  <SupportedHardwareVersion>vmx-04</SupportedHardwareVersion>
                  <SupportedHardwareVersion>vmx-07</SupportedHardwareVersion>
                  <SupportedHardwareVersion>vmx-08</SupportedHardwareVersion>
              </SupportedHardwareVersions>
          </Capabilities>
          <NicQuota>0</NicQuota>
          <NetworkQuota>1024</NetworkQuota>
          <VmQuota>0</VmQuota>
          <IsEnabled>true</IsEnabled>
      </Vdc>}
    end
  end
end