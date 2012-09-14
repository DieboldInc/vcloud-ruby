module VCloud
  class Reference
    attr_reader :name, :type, :href, :id

    def initialize(args)
      @name = args[:name]
      @type = args[:type]
      @href = args[:href]
      @id = args[:id]
    end
    
    def self.FromXML(ref)
      doc = XmlSimple.xml_in(ref)
      new(        
        name: doc['name'], 
        type: doc['type'], 
        href: doc['href'],
        id: doc['id']) 
    end
  end
end