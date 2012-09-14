module VCloud
  module XmlElement
    

    
      private
      
      def references_from_xml(xml, ref_xpath)
        doc = Nokogiri::XML(xml)
        doc.remove_namespaces!
        elems = doc.xpath(ref_xpath)
        refs = elems.collect { |e| Reference.from_xml(e.to_s) }
        refs
      end
        
      def links_from_xml(xml)        
        iterate_over_xml_elements(xml, VCloud::Constants::Xpath::LINK) do |elems|
          elems.collect { |e| Link.from_xml(e.to_s) }
        end
      end
      
      def iterate_over_xml_elements(xml, elem_xpath, &block)
        doc = Nokogiri::XML(xml)
        doc.remove_namespaces!
        elems = doc.xpath(elem_xpath)
        yield(elems)
      end
    
    
  end
end