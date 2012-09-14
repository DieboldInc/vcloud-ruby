module VCloud
  module ParsesXml

    private

    def references_from_xml(xml, ref_xpath)
      iterate_over_xml_elements(xml, ref_xpath) do |elems|
        elems.collect { |e| Reference.from_xml(e.to_s) }
      end
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