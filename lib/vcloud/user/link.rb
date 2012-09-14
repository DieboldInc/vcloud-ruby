module VCloud
  class Link
    attr_reader :rel, :type, :href

    def initialize(args)
      @rel = args[:rel]
      @type = args[:type]
      @href = args[:href]
    end

    def self.from_xml(xml)
      doc = XmlSimple.xml_in(xml)
      new(
        rel: doc['rel'], 
        type: doc['type'], 
        href: doc['href']) 
    end
  end
end