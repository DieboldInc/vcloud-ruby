module VCloud
  module ParsesXml
    def self.included(base)
      base.send(:include, HappyMapper)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def has_links
        self.class_eval do
          has_many :links, VCloud::Link, :xpath => '.'
        end
      end

      def has_default_attributes
        self.class_eval do
          attribute :id, 'String'
          attribute :type, 'String'
          attribute :name, 'String'
          attribute :href, 'String'           
        end
      end
      
      def from_xml(xml)
        parse(xml)
      end
    end

    def parse_xml(xml)
      parse(xml)
    end
  end
end