module VCloud   
  Dir[File.expand_path("../user/*.rb", __FILE__)].each do |file|
    require file
  end
end