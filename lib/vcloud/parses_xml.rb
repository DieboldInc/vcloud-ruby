module VCloud
  module ParsesXml
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def has_links
        parse_ops << lambda { |doc|
              links = doc.xpath(VCloud::Constants::Xpath::LINK).collect { |e| Link.from_xml(e.to_s) }
              return {:links => links} 
            }
      end

      def has_reference(name, xpath)
        parse_ops << lambda { |doc|
            refs = doc.xpath(xpath).collect { |e| Reference.from_xml(e.to_s) }
            return {name => refs}
          }
      end

      def parse_ops
        @parse_ops ||= []
      end
    end

    def parse_xml(xml)
      doc = Nokogiri::XML(xml)
      result = {}
      self.class.parse_ops.each do |op|
        result.merge!(op.call(doc))
      end
      result
    end
  end
end