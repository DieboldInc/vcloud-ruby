module VCloud
  require 'vcloud/user/reference'
  
  Dir[File.expand_path("../user/references/*.rb", __FILE__)].each do |file|
    require file
  end
  
  Dir[File.expand_path("../user/*.rb", __FILE__)].each do |file|
    require file
  end
end