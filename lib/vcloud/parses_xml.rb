module VCloud
  module ParsesXml
    
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def xml_parsing_rules(&block)
        self.extend(ParseDSL)
        self.instance_eval(&block)
      end

      def parse_ops
        @@parse_ops ||= []
      end

      def parse_xml(xml)
        @doc = Nokogiri::XML(xml)
        result = {}
        parse_ops.each do |op|
          result.merge!(op.call)
        end
        result
      end
    end

    module ParseDSL
      def has_links
        parse_ops << lambda { return {:links => method(:links_from_xml).call} }
      end

      def has_reference(name, xpath)
        parse_ops << lambda { return {name => method(:references_from_xml).call(xpath)} }
      end

      def references_from_xml(ref_xpath)
        iterate_over_xml_elements(ref_xpath) do |elems|
          elems.collect { |e| Reference.from_xml(e.to_s) }
        end
      end

      def links_from_xml()        
        iterate_over_xml_elements(VCloud::Constants::Xpath::LINK) do |elems|
          elems.collect { |e| Link.from_xml(e.to_s) }
        end
      end

      def iterate_over_xml_elements(elem_xpath, &block)
        elems = @doc.xpath(elem_xpath)
        yield(elems)
      end      
    end

  end
end