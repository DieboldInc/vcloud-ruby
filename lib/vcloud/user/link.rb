module VCloud
  class Link
    attr_reader :rel, :type, :name, :href

    def initialize(args)
      @rel = args[:rel]
      @type = args[:type]
      @name = args[:name]
      @href = args[:href]
    end

    def self.from_xml(xml)
      doc = XmlSimple.xml_in(xml)
      new(
        rel: doc['rel'], 
        type: doc['type'], 
        name: doc['name'],
        href: doc['href']) 
    end
  end
end