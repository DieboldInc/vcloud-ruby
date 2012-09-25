module VCloud
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

    def self.from_xml(xml)
      parse(xml)
    end
  end
end