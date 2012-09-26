module VCloud
  class Link
    include HappyMapper
    
    tag 'Link'
    attribute :rel, 'String'
    attribute :type, 'String'
    attribute :name, 'String'
    attribute :href, 'String'

    def initialize(args = {})
      @rel = args[:rel]
      @type = args[:type]
      @name = args[:name]
      @href = args[:href]
    end

    def self.from_xml(xml)
      parse(xml)
    end
  end
end