module VCloud
  class VApp < BaseVCloudEntity
    include ParsesXml

    has_type VCloud::Constants::ContentType::VAPP
    has_links
    has_default_attributes
    has_tasks
    
  end
end