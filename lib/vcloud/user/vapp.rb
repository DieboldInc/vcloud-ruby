module VCloud
  # A vApp is a collection of VMs, network config, etc.
  class VApp < BaseVCloudEntity
    include ParsesXml

    has_type VCloud::Constants::ContentType::VAPP
    tag 'VApp'
    has_links
    has_default_attributes
    has_many :tasks, VCloud::Task
  end
end