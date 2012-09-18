module VCloud
  module ParsesXml
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def has_links
        self.class_eval do
          attr_reader :links
        end        
        
        parse_ops << lambda { |doc, instance = nil|          
              links = doc.xpath(VCloud::Constants::Xpath::LINK).collect { |e| Link.from_xml(e.to_s) }
              if instance
                instance.instance_variable_set(:@links, links)
              else
                return {:links => links}
              end 
            }
      end

      def has_reference(name, xpath)        
        self.class_eval do
          attr_reader name
        end
        
        parse_ops << lambda { |doc, instance = nil |
            refs = doc.xpath(xpath).collect { |e| Reference.from_xml(e.to_s) }
            if instance
              instance.instance_variable_set("@#{name}".to_sym, refs)
            else
              return {name => refs}
            end
          }
      end

      def has_default_attributes
        self.class_eval do
          attr_reader :name, :type, :href, :id              
        end
        
        parse_ops << lambda { |doc, instance = nil|
          if instance
            instance.instance_variable_set(:@name, doc.root.attr("name"))
            instance.instance_variable_set(:@type, doc.root.attr("type"))
            instance.instance_variable_set(:@href, doc.root.attr("href"))
            instance.instance_variable_set(:@id, doc.root.attr("id"))
          else
            return {
              :name => doc.root.attr("name"),
              :type => doc.root.attr("type"),
              :href => doc.root.attr("href"),
              :id => doc.root.attr("id")}
          end
        }
      end

      def parse_ops
        @parse_ops ||= []
      end
      
      def parse_xml(xml, instance = nil)
        doc = Nokogiri::XML(xml)
        result = {:doc => doc}
        parse_ops.each do |op|
          op_result = op.call(doc, instance)
          result.merge!(op_result) if not instance
        end
        result
      end
    end

    def parse_xml(xml)
      self.class.parse_xml(xml, self)
    end
  end
end