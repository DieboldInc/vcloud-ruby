module VCloud
  class InstantiateVAppTemplateParams

    attr_accessor :name, :deploy, :power_on, :description, :source, :network_configs

    def initialize
      @network_configs = []
      @deploy = true
      @power_on = true
    end
    
    def to_xml
      builder = Nokogiri::XML::Builder.new(:encoding => VCloud::Constants::XML_ENCODING) do |xml|
        xml.InstantiateVAppTemplateParams(:name => @name, :deploy => @deploy, :powerOn => @power_on) {
          xml.Description @description
          xml.InstantiationParams {
           xml.NetworkConfigSection {
             @network_configs.each do |network|
               xml.NetworkConfig(:networkName => network.name) {
                 xml.Configuration {
                   xml.ParentNetwork(:href => network.href)
                   xml.FenceMode 'bridged'
                 }
               }
             end
           } 
          }
          xml.Source(:href => @source)
        }
      end
      builder.to_xml
    end

  end
end