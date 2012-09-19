module VCloud
  class InstantiateVAppTemplateParams

    attr_accessor :name, :deploy, :power_on, :description, :source_ref, :instantiation_param_items

    def initialize
      @instantiation_param_items = []
      @deploy = true
      @power_on = false
    end
    
    def to_xml
      builder = Nokogiri::XML::Builder.new(:encoding => VCloud::Constants::XML_ENCODING) do |xml|
        xml.InstantiateVAppTemplateParams(
                :name => @name, 
                :deploy => @deploy, 
                :powerOn => @power_on, 
                :xmlns => VCloud::Constants::NameSpace::V1_5,
                'xmlns:xsi' => VCloud::Constants::NameSpace::XSI,
                'xmlns:ovf' => VCloud::Constants::NameSpace::OVF) {
          xml.Description @description
          xml.InstantiationParams {
            @instantiation_param_items.each do |item|
              xml << item.to_xml
            end            
          }
          xml.Source(:href => @source_ref.href)
        }
      end
      builder.to_xml
    end

  end
end