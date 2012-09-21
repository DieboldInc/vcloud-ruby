module VCloud
  class Task
    
    attr_reader :status, :start_time, :operation_name, :operation, :expiry_time, :name, :id, :href, :links

    def initialize(args)
      @status = args[:status]
      @start_time = args[:start_time]
      @operation_name = args[:operation_name]
      @operation = args[:operation]
      @expiry_time = args[:expiry_time]
      @name = args[:name]
      @id = args[:id]
      @href = args[:href]
      @links = args[:links]
    end

    def self.from_xml(xml)
      doc = XmlSimple.xml_in(xml)
      
      links = []
      doc['Link'].each do |link|
        links << VCloud::Link.new(rel: link['rel'], href: link['href'])
      end
      
      new(
        status: doc['status'],
        start_time: doc['startTime'],
        operation_name: doc['operationName'],
        operation: doc['operation'],
        expiry_time: doc['expiryTime'],
        name: doc['name'],
        id: doc['id'],
        href: doc['href'],
        links: links
      )
    end
  end
end