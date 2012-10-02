module VCloud
  # A reference to a resource. Contains an href attribute and optional name and type attributes.
  class Reference
    include HappyMapper 
    
    tag '*'
    attribute :id, 'String'
    attribute :type, 'String'
    attribute :name, 'String'
    attribute :href, 'String'

    def initialize(args = {})
      @rel = args[:id]
      @type = args[:type]
      @name = args[:name]
      @href = args[:href]
    end

    # Parse a VCloud::Reference from XML
    #
    # @param [String] xml XML to parse
    # @return [VCloud::Reference] Reference that is parsed from the XML
    def self.from_xml(xml)
      parse(xml)
    end
  end
end