module VCloud
  Dir[File.expand_path("../user/*", __FILE__)].each do |file|
    require file
  end
end