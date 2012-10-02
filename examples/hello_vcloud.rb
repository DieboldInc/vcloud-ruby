$:.unshift File.join( File.dirname( __FILE__ ), '..', 'lib')
require 'vcloud'

# Check for command line arguments
if ARGV.length != 7
  puts "hello_vcloud.rb vCloudURL user@vcloud-organization password orgName vdcName ovfFileLocation catalogName"
  exit
else
  @url = ARGV[0]
  @username = ARGV[1]
  @password = ARGV[2]
  @org_name = ARGV[3]
  @vdc_name = ARGV[4]
  @catalog_item_name = ARGV[5]
  @catalog_name = ARGV[6]
end

puts "###############################################"
puts "1. Log in and retrieve Org"
puts "###############################################"
puts

@session = VCloud::Client.new(@url, '1.5', :verify_ssl => false)
@session.login(@username, @password)

puts 'Available orgs'
puts '--------------'
@session.get_org_refs.each do |org_ref|
  puts org_ref.name
end

@org = @session.get_org_from_name(@org_name)
## ---
## or get the org from a reference
## ---
# org_ref_hash = @session.get_org_refs_by_name
# org_ref      = org_ref_hash[@org_name]
# @org         = VCloud::Org.from_reference(org_ref, @session) 

puts
puts "Selected org: #{@org.name}"

puts
puts "###############################################"
puts "2. Find a Catalog and a vDC"
puts "###############################################"
puts

@catalog = @org.get_catalog_from_name(@catalog_name)
@vdc     = @org.get_vdc_from_name(@vdc_name)      
## ---
## or get the catalog and vdc from a link
## ---                                        
# catalog_link_hash = @org.get_catalog_links_by_name
# catalog_link      = catalog_link_hash[@catalog_name]
# @catalog          = VCloud::Catalog.from_reference(catalog_link, @session)  
# 
# vdc_link_hash = @org.get_vdc_links_by_name
# vdc_link      = vdc_link_hash[@vdc_name]
# @vdc          = VCloud::Vdc.from_reference(vdc_link, @session)   

puts "Selected catalog: #{@catalog.name}"
puts "Selected vdc:     #{@vdc.name}"

puts
puts "###############################################"
puts "4. Retrieve a Catalog Item"
puts "###############################################"
puts

@catalog_item = @catalog.get_catalog_item_from_name(@catalog_item_name)
## ---
## or get the catalog_item from a reference
## ---                                        
# catalog_item_ref_hash = @catalog.get_catalog_item_refs_by_name
# catalog_item_ref      = catalog_item_ref_hash[@catalog_item_name]
# @catalog_item         = VCloud::CatalogItem.from_reference(catalog_item_ref, @session)    

@vapp_ref = @catalog_item.entity_reference

puts "Selected catalog item: #{@catalog_item.name}"

puts
puts "###############################################"
puts "5. Retrieve Deployment Information From the vDC"
puts "###############################################"
puts

@network_ref = @vdc.network_references.first

puts "Selected network: #{@network_ref.name}"

puts
puts "###############################################"
puts "6. Deploy the vApp"
puts "###############################################"
puts

net_config                          = VCloud::NetworkConfig.new
net_config.network_name             = @network_ref.name
net_config.parent_network_reference = @network_ref
net_config.fence_mode               = VCloud::NetworkConfig::FenceMode::BRIDGED       

@vapp_template = VCloud::InstantiateVAppTemplateParams.new
@vapp_template.name        = "HelloVCloud-VappTemplate"
@vapp_template.description = "HelloVCloud-VappTemplate description"
@vapp_template.power_on    = false
@vapp_template.deploy      = false
@vapp_template.network_config_section = VCloud::NetworkConfigSection.new
@vapp_template.network_config_section.network_configs << net_config
@vapp_template.source_reference = @vapp_ref

@vapp = @vdc.instantiate_vapp_template(@vapp_template)

print "Deploying vapp #{@vapp.name}...."
if @vapp.tasks.count > 0 
  @vapp.tasks.first.wait_to_finish { @vapp.refresh } 
end                                     
puts "Deployed."

puts
puts "###############################################"
puts "7. Operate the vApp"
puts "###############################################"
puts

print "Powering on vapp #{@vapp.name}..."
@vapp.power_on.wait_to_finish { @vapp.refresh }
puts 'Powered on.'

print "Suspending vapp #{@vapp.name}..."
@vapp.undeploy(VCloud::VApp::UndeployPowerAction::SUSPEND).wait_to_finish { @vapp.refresh }
puts "Suspended." 

print "Powering on vapp #{@vapp.name}..."
@vapp.power_on.wait_to_finish { @vapp.refresh }
puts 'Powered on.'

puts
puts "###############################################"
puts "8. Displaying the Virtual Machine Console"
puts "###############################################"
puts

puts
puts "###############################################"
puts "9. Delete the vApp"
puts "###############################################"
puts 

print "Powering off vapp #{@vapp.name}..."
@vapp.undeploy(VCloud::VApp::UndeployPowerAction::POWER_OFF).wait_to_finish { @vapp.refresh }
puts 'Undeployed.'      

print "Removing vapp #{@vapp.name}..."
@vapp.remove.wait_to_finish
puts 'Removed.'                              

puts
puts "###############################################"
puts "10. Log Out"
puts "###############################################" 

@session.logout