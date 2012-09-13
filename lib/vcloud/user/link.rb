module VCloud
  module User
    class Link
      
      attr_reader :rel, :type, :href
      
      def initialize(args)
        @rel = args[:rel]
        @type = args[:type]
        @href = args[:href]
      end
      
      def self.FromXML(link)
          doc = XmlSimple.xml_in(link)
          new(
            rel: doc['rel'], 
            type: doc['type'], 
            href: doc['href']) 
      end
      
    end
  end
end


