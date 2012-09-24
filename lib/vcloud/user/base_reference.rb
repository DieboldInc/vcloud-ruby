module VCloud
  module BaseReference    
    def self.included(base)
      base.attribute :id, 'String'
      base.attribute :type, 'String'
      base.attribute :name, 'String'
      base.attribute :href, 'String'
    end

    def initialize(args = {})
      @rel = args[:id]
      @type = args[:type]
      @name = args[:name]
      @href = args[:href]
    end

    def self.from_xml(xml)
      parse(xml)
    end
  end
end