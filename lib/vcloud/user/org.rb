module VCloud
  class Org

    attr_reader :type, :name, :href, :vdcs, :catalogs, :networks

    def initialize(args)
      @type = args[:type]
      @name = args[:name]
      @href = args[:href]
      
      @vdcs = []
      @catalogs = []
      @networks = []

    end

    def self.FromXML(org_xml)
      doc = XmlSimple.xml_in(org_xml)
      new(
      type: doc['type'], 
      name: doc['name'], 
      href: doc['href'])
    end

  end
end