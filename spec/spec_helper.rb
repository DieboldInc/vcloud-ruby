require 'webmock/rspec'

require_relative '../lib/vcloud'

RSpec.configure do |config|
  config.before(:each) {
    stub_request(:post, "https://someuser%40someorg:password@some.vcloud.com/api/sessions").
             with(:headers => {'Accept'=>'application/*+xml;version=1.5', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'}).
             to_return(:status => 200, :body => VCloud::Test::Data::SESSION_XML, :headers => {:x_vcloud_authorization => "abc123xyz"})
             
             
    @session = VCloud::Client.new(VCloud::Test::Constants::API_URL, VCloud::Test::Constants::API_VERSION)
    @session.login(VCloud::Test::Constants::USERNAME_WITH_ORG, VCloud::Test::Constants::PASSWORD)
    VCloud::Session.set_session(@session)
  }
end

module VCloud
  module Test
    module Constants
      API_URL = "https://some.vcloud.com/api/"
      API_VERSION = "1.5"
      USERNAME = "someuser"
      USERNAME_WITH_ORG = "someuser@someorg"
      PASSWORD = "password"
    end
  end
end

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
      <Catalog xmlns="http://www.vmware.com/vcloud/v1.5" name="SuperCool Catalog" id="urn:vcloud:catalog:aaa-bbb-ccc-ddd-eee-fff" type="application/vnd.vmware.vcloud.catalog+xml" href="https://some.vcloud.com/api/catalog/aaa-bbb-ccc-ddd-eee-fff" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.vmware.com/vcloud/v1.5 http://127.0.0.1/api/v1.5/schema/master.xsd">
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
      <Vdc xmlns="http://www.vmware.com/vcloud/v1.5" status="1" name="TestVDC" id="urn:vcloud:vdc:aaa-bbb-ccc-ddd-eee-fff" type="application/vnd.vmware.vcloud.vdc+xml" href="https://some.vcloud.com/api/vdc/aaa-bbb-ccc-ddd-eee-fff" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.vmware.com/vcloud/v1.5 http://127.0.0.1/api/v1.5/schema/master.xsd">
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
      
      
      VAPP_TEMPLATE_XML = %q{<?xml version="1.0" encoding="UTF-8"?>
      <VAppTemplate xmlns="http://www.vmware.com/vcloud/v1.5" xmlns:ovf="http://schemas.dmtf.org/ovf/envelope/1" ovfDescriptorUploaded="true" goldMaster="false" status="8" name="Ubuntu 10.04.4 LTS" id="urn:vcloud:vapptemplate:aaa-bbb-ccc-ddd-eee-fff" type="application/vnd.vmware.vcloud.vAppTemplate+xml" href="https://some.vcloud.com/api/vAppTemplate/vappTemplate-aaa-bbb-ccc-ddd-eee-fff" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://schemas.dmtf.org/ovf/envelope/1 http://schemas.dmtf.org/ovf/envelope/1/dsp8023_1.1.0.xsd http://www.vmware.com/vcloud/v1.5 http://127.0.0.1/api/v1.5/schema/master.xsd">
          <Link rel="catalogItem" type="application/vnd.vmware.vcloud.catalogItem+xml" href="https://some.vcloud.com/api/catalogItem/aaa-bbb-ccc-ddd-eee-fff"/>
          <Link rel="enable" href="https://some.vcloud.com/api/vAppTemplate/vappTemplate-aaa-bbb-ccc-ddd-eee-fff/action/enableDownload"/>
          <Link rel="disable" href="https://some.vcloud.com/api/vAppTemplate/vappTemplate-aaa-bbb-ccc-ddd-eee-fff/action/disableDownload"/>
          <Link rel="ovf" type="text/xml" href="https://some.vcloud.com/api/vAppTemplate/vappTemplate-aaa-bbb-ccc-ddd-eee-fff/ovf"/>
          <Link rel="down" type="application/vnd.vmware.vcloud.owner+xml" href="https://some.vcloud.com/api/vAppTemplate/vappTemplate-aaa-bbb-ccc-ddd-eee-fff/owner"/>
          <Link rel="down" type="application/vnd.vmware.vcloud.metadata+xml" href="https://some.vcloud.com/api/vAppTemplate/vappTemplate-aaa-bbb-ccc-ddd-eee-fff/metadata"/>
          <Description/>
          <Owner type="application/vnd.vmware.vcloud.owner+xml">
              <User type="application/vnd.vmware.admin.user+xml" name="system" href="https://some.vcloud.com/api/admin/user/aaa-bbb-ccc-ddd-eee-fff"/>
          </Owner>
          <Children>
              <Vm goldMaster="false" name="Ubuntu 10.04.4 LTS" id="urn:vcloud:vm:aaa-bbb-ccc-ddd-eee-fff" type="application/vnd.vmware.vcloud.vm+xml" href="https://some.vcloud.com/api/vAppTemplate/vm-aaa-bbb-ccc-ddd-eee-fff">
                  <Link rel="up" type="application/vnd.vmware.vcloud.vAppTemplate+xml" href="https://some.vcloud.com/api/vAppTemplate/vappTemplate-aaa-bbb-ccc-ddd-eee-fff"/>
                  <Link rel="down" type="application/vnd.vmware.vcloud.metadata+xml" href="https://some.vcloud.com/api/vAppTemplate/vm-aaa-bbb-ccc-ddd-eee-fff/metadata"/>
                  <Description/>
                  <NetworkConnectionSection type="application/vnd.vmware.vcloud.networkConnectionSection+xml" href="https://some.vcloud.com/api/vAppTemplate/vm-aaa-bbb-ccc-ddd-eee-fff/networkConnectionSection/" ovf:required="false">
                      <ovf:Info>Specifies the available VM network connections</ovf:Info>
                      <PrimaryNetworkConnectionIndex>0</PrimaryNetworkConnectionIndex>
                      <NetworkConnection network="none" needsCustomization="true">
                          <NetworkConnectionIndex>0</NetworkConnectionIndex>
                          <IsConnected>false</IsConnected>
                          <MACAddress>00:00:00:00:00:00</MACAddress>
                          <IpAddressAllocationMode>NONE</IpAddressAllocationMode>
                      </NetworkConnection>
                  </NetworkConnectionSection>
                  <GuestCustomizationSection type="application/vnd.vmware.vcloud.guestCustomizationSection+xml" href="https://some.vcloud.com/api/vAppTemplate/vm-aaa-bbb-ccc-ddd-eee-fff/guestCustomizationSection/" ovf:required="false">
                      <ovf:Info>Specifies Guest OS Customization Settings</ovf:Info>
                      <Enabled>true</Enabled>
                      <ChangeSid>false</ChangeSid>
                      <VirtualMachineId>vm-aaa-bbb-ccc-ddd-eee-fff</VirtualMachineId>
                      <JoinDomainEnabled>false</JoinDomainEnabled>
                      <UseOrgSettings>false</UseOrgSettings>
                      <AdminPasswordEnabled>true</AdminPasswordEnabled>
                      <AdminPasswordAuto>true</AdminPasswordAuto>
                      <ResetPasswordRequired>false</ResetPasswordRequired>
                      <ComputerName>Ubuntu10044-001</ComputerName>
                  </GuestCustomizationSection>
                  <VAppScopedLocalId>Ubuntu 10.04.4 LTS</VAppScopedLocalId>
              </Vm>
          </Children>
          <ovf:NetworkSection xmlns:vcloud="http://www.vmware.com/vcloud/v1.5" vcloud:href="https://some.vcloud.com/api/vAppTemplate/vappTemplate-aaa-bbb-ccc-ddd-eee-fff/networkSection/" vcloud:type="application/vnd.vmware.vcloud.networkSection+xml">
              <ovf:Info>The list of logical networks</ovf:Info>
              <ovf:Network ovf:name="none">
                  <ovf:Description>This is a special place-holder used for disconnected network interfaces.</ovf:Description>
              </ovf:Network>
          </ovf:NetworkSection>
          <NetworkConfigSection type="application/vnd.vmware.vcloud.networkConfigSection+xml" href="https://some.vcloud.com/api/vAppTemplate/vappTemplate-aaa-bbb-ccc-ddd-eee-fff/networkConfigSection/" ovf:required="false">
              <ovf:Info>The configuration parameters for logical networks</ovf:Info>
              <NetworkConfig networkName="none">
                  <Description>This is a special place-holder used for disconnected network interfaces.</Description>
                  <Configuration>
                      <IpScope>
                          <IsInherited>false</IsInherited>
                          <Gateway>192.168.0.1</Gateway>
                          <Netmask>255.255.255.0</Netmask>
                          <Dns1>192.168.0.100</Dns1>
                      </IpScope>
                      <FenceMode>isolated</FenceMode>
                  </Configuration>
                  <IsDeployed>false</IsDeployed>
              </NetworkConfig>
          </NetworkConfigSection>
          <LeaseSettingsSection type="application/vnd.vmware.vcloud.leaseSettingsSection+xml" href="https://some.vcloud.com/api/vAppTemplate/vappTemplate-aaa-bbb-ccc-ddd-eee-fff/leaseSettingsSection/" ovf:required="false">
              <ovf:Info>Lease settings section</ovf:Info>
              <Link rel="edit" type="application/vnd.vmware.vcloud.leaseSettingsSection+xml" href="https://some.vcloud.com/api/vAppTemplate/vappTemplate-aaa-bbb-ccc-ddd-eee-fff/leaseSettingsSection/"/>
              <StorageLeaseInSeconds>0</StorageLeaseInSeconds>
          </LeaseSettingsSection>
          <CustomizationSection type="application/vnd.vmware.vcloud.customizationSection+xml" href="https://some.vcloud.com/api/vAppTemplate/vappTemplate-aaa-bbb-ccc-ddd-eee-fff/customizationSection/" ovf:required="false">
              <ovf:Info>VApp template customization section</ovf:Info>
              <CustomizeOnInstantiate>true</CustomizeOnInstantiate>
          </CustomizationSection>
      </VAppTemplate>}
      
      VAPP_XML = %q{<?xml version="1.0" encoding="UTF-8"?>
      <VApp xmlns="http://www.vmware.com/vcloud/v1.5" deployed="false" status="0" name="Linux FTP server" id="urn:vcloud:vapp:aaa-bbb-ccc-ddd-eee-fff" type="application/vnd.vmware.vcloud.vApp+xml" href="https://some.vcloud.com/api/vApp/vapp-aaa-bbb-ccc-ddd-eee-fff" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.vmware.com/vcloud/v1.5 http://127.0.0.1/api/v1.5/schema/master.xsd">
          <Link rel="down" type="application/vnd.vmware.vcloud.vAppNetwork+xml" name="Dev CLAN" href="https://some.vcloud.com/api/network/aaa-bbb-ccc-ddd-eee-fff"/>
          <Link rel="down" type="application/vnd.vmware.vcloud.controlAccess+xml" href="https://some.vcloud.com/api/vApp/vapp-aaa-bbb-ccc-ddd-eee-fff/controlAccess/"/>
          <Link rel="up" type="application/vnd.vmware.vcloud.vdc+xml" href="https://some.vcloud.com/api/vdc/aaa-bbb-ccc-ddd-eee-fff"/>
          <Link rel="down" type="application/vnd.vmware.vcloud.owner+xml" href="https://some.vcloud.com/api/vApp/vapp-aaa-bbb-ccc-ddd-eee-fff/owner"/>
          <Link rel="down" type="application/vnd.vmware.vcloud.metadata+xml" href="https://some.vcloud.com/api/vApp/vapp-aaa-bbb-ccc-ddd-eee-fff/metadata"/>
          <Description>Ruby VCloud RSpec Test</Description>
          <Tasks>
              <Task status="running" startTime="2012-09-20T10:40:08.286-04:00" operationName="vdcInstantiateVapp" operation="Creating Virtual Application Linux FTP server(aaa-bbb-ccc-ddd-eee-fff)" expiryTime="2012-12-19T10:40:08.286-05:00" name="task" id="urn:vcloud:task:aaa-bbb-ccc-ddd-eee-fff" type="application/vnd.vmware.vcloud.task+xml" href="https://some.vcloud.com/api/task/aaa-bbb-ccc-ddd-eee-fff">
                  <Link rel="task:cancel" href="https://some.vcloud.com/api/task/aaa-bbb-ccc-ddd-eee-fff/action/cancel"/>
                  <Owner type="application/vnd.vmware.vcloud.vApp+xml" name="Linux FTP server" href="https://some.vcloud.com/api/vApp/vapp-aaa-bbb-ccc-ddd-eee-fff"/>
                  <User type="application/vnd.vmware.admin.user+xml" name="someuser" href="https://some.vcloud.com/api/admin/user/aaa-bbb-ccc-ddd-eee-fff"/>
                  <Organization type="application/vnd.vmware.vcloud.org+xml" name="someorg" href="https://some.vcloud.com/api/org/aaa-bbb-ccc-ddd-eee-fff"/>
                  <Progress>1</Progress>
              </Task>
          </Tasks>
          <Owner type="application/vnd.vmware.vcloud.owner+xml">
              <User type="application/vnd.vmware.admin.user+xml" name="someuser" href="https://some.vcloud.com/api/admin/user/aaa-bbb-ccc-ddd-eee-fff"/>
          </Owner>
          <InMaintenanceMode>false</InMaintenanceMode>
      </VApp>}
    end
  end
end