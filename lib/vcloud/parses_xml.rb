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
      
      def parse_xml(xml)
        doc = Nokogiri::XML(xml)
        result = {:doc => doc}
        parse_ops.each do |op|
          result.merge!(op.call(doc))
        end
        result
      end
    end

    def parse_xml(xml)
      self.class.parse_xml(xml)
    end
  end
end