require 'spec_helper'

include WebMock::API

describe VCloud::InstantiateVAppTemplateParams do
  
  before(:each) do
    
  end
  
  it "creates a new InstantiateVAppTemplateParams" do
    vapp_params = VCloud::InstantiateVAppTemplateParams.new
    vapp_params.name = 'SomeVAppTemplateParams'
    vapp_params.description = 'some descriptive string'
    vapp_params.source = VCloud::SourceReference.new({})
    
    vapp_params.should_not == nil
    vapp_params.name.should == "SomeVAppTemplateParams"
    vapp_params.description.should == "some descriptive string"
    vapp_params.source.should_not == nil
    vapp_params.instantiation_param_items.should have(0).items
    vapp_params.deploy.should == true
    vapp_params.power_on.should == false    
  end
  
  it "seralizes to XML" do
    vapp_params = VCloud::InstantiateVAppTemplateParams.new
    vapp_params.name = 'SomeVAppTemplateParams'
    vapp_params.description = 'some descriptive string'
    vapp_params.source = VCloud::SourceReference.new({})
    
    xml = vapp_params.to_xml
    doc = Nokogiri::XML(xml)
    
    doc.at_xpath('/xmlns:InstantiateVAppTemplateParams')['name'].should == "SomeVAppTemplateParams"
    doc.at_xpath('/xmlns:InstantiateVAppTemplateParams')['deploy'].should == "true"
    doc.at_xpath('/xmlns:InstantiateVAppTemplateParams/xmlns:Description').text.should == "some descriptive string"
  end
end