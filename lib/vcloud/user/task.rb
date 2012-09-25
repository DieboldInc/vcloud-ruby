module VCloud
  class Task < BaseVCloudEntity
    include ParsesXml
    
    has_type VCloud::Constants::ContentType::TASK
    tag 'Task'
    has_links
    has_default_attributes
    attribute :status, String
    attribute :start_time, String, :tag => 'startTime' 
    attribute :operation_name, String, :tag => 'operationName'
    attribute :operation, String
    attribute :expiry_time, String, :tag => 'expiryTime'

    def self.from_xml(xml)
      # doc = XmlSimple.xml_in(xml)
      # 
      # links = []
      # doc['Link'].each do |link|
      #   links << VCloud::Link.new(rel: link['rel'], href: link['href'])
      # end
      # 
      # new(
      #   status: doc['status'],
      #   start_time: doc['startTime'],
      #   operation_name: doc['operationName'],
      #   operation: doc['operation'],
      #   expiry_time: doc['expiryTime'],
      #   name: doc['name'],
      #   id: doc['id'],
      #   href: doc['href'],
      #   links: links
      # ) 
    end
  end
end