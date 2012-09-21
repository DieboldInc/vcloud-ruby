module VCloud
  class VApp < BaseVCloudEntity
    include ParsesXml

    has_type VCloud::Constants::ContentType::VAPP
    has_links
    has_default_attributes
    has_tasks
    
    def self.from_xml(xml)
      doc = parse_xml(xml)
      obj = new(
        name: doc[:name],
        links: doc[:links],
        type: doc[:type],
        href: doc[:href],
        id: doc[:id],
        tasks: doc[:tasks],
      )
    end
  end
end