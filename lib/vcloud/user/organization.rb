require 'xmlsimple'

module VCloud
  module User
    class Organization
      
      attr_reader :type, :name, :href
      
      def initialize(args)
        @type = args[:type]
        @name = args[:name]
        @href = args[:href]
        
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
end