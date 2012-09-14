module VCloud
  class Reference    
    attr_reader :name, :type, :href, :id

    def initialize(args)
      @name = args[:name]
      @type = args[:type]
      @href = args[:href]
      @id = args[:id]
    end
    
    def self.from_xml(xml)
      doc = XmlSimple.xml_in(xml)
      new(        
        name: doc['name'], 
        type: doc['type'], 
        href: doc['href'],
        id:   doc['id']) 
    end
  end
end