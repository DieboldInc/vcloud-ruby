$:.unshift File.join( File.dirname( __FILE__ ), '..', 'lib')
require 'vcloud'

# Check for command line arguments
if ARGV.length == 0
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

@session = VCloud::Client.new(@url, '1.5')
@session.login(@username, @password)

@org = @session.get_org_from_name(@org_name)

puts "###############################################"
puts "2. Find a Catalog and a vDC"
puts "###############################################"

@catalog = @org.get_catalog_from_name(@catalog_name)
@vdc = @org.get_vdc_from_name(@vdc_name)

puts "###############################################"
puts "3. Retrieve the Contents of a Catalog"
puts "###############################################"

puts "###############################################"
puts "4. Retrieve a Catalog Item"
puts "###############################################"

@catalog_item = @catalog.get_catalog_item_from_name(@catalog_item_name)

puts "###############################################"
puts "5. Retrieve Deployment Information From the vDC"
puts "###############################################"

puts "###############################################"
puts "6. Deploy the vApp"
puts "###############################################"

puts "###############################################"
puts "7. Get Information About a vApp"
puts "###############################################"

puts "###############################################"
puts "8. Displaying the Virtual Machine Console"
puts "###############################################"

puts "###############################################"
puts "9. Delete the vApp"
puts "###############################################"

puts "###############################################"
puts "10. Log Out"
puts "###############################################"