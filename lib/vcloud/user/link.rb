module VCloud
  # Defines a hyper-link with a relationship, hyper-link reference, and an optional MIME type
  class Link
    include HappyMapper
    
    tag 'Link'
    attribute :rel, 'String'
    attribute :type, 'String'
    attribute :name, 'String'
    attribute :href, 'String'

    # A new instance of Link
    #
    # @param args [Hash{String => String}] Named arguments, 'rel', 'type', 'name' and 'href'
    def initialize(args = {})
      @rel = args[:rel]
      @type = args[:type]
      @name = args[:name]
      @href = args[:href]
    end

    # Parses XML to produce a VCloud::Link
    #
    # @param [String] xml XML to parse
    # @return [VCloud::Link] Link object parsed from the XML
    def self.from_xml(xml)
      parse(xml)
    end
  end
end