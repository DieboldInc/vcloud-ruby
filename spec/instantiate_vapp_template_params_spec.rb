require 'spec_helper'

include WebMock::API

describe VCloud::InstantiateVAppTemplateParams do
   
  it 'should #initialize' do
    params = VCloud::InstantiateVAppTemplateParams.new
    params.name.should == ''
    params.deploy.should == true
    params.power_on.should == false
    params.description.should == ''
    params.network_config_section.should be_nil
    params.source_reference.should be_nil
    params.is_source_delete.should == false
    params.all_eulas_accepted.should == false
  end
  
  describe 'when parsing xml #from_xml' do
    before(:each) do
      @params = VCloud::InstantiateVAppTemplateParams.from_xml(fixture_file('instantiate_vapp_template_params.xml'))
    end
    
    it 'should have correct values' do
      @params.name.should == 'SomeVAppTemplateParams'
      @params.deploy.should == true
      @params.power_on.should == false
      @params.description.should == 'some descriptive string'
      @params.network_config_section.should_not be_nil
      @params.source_reference.href.should == 'https://vcloud.example.com/api/vAppTemplate/vappTemplate-111'
      @params.is_source_delete.should == false
      @params.all_eulas_accepted.should == true
    end    
  end


  it "should serialize #to_xml" do
    params = VCloud::InstantiateVAppTemplateParams.new
    params.name = 'SomeVAppTemplateParams'
    params.deploy = false
    params.power_on = true
    params.description = 'some descriptive string'
    params.network_config_section = 'blagow'
    params.source_reference =  VCloud::Reference.new :href => 'https://vcloud.example.com/api/vAppTemplate/vappTemplate-111'
    params.is_source_delete = true
    params.all_eulas_accepted = true    

    xml = params.to_xml
    doc = Nokogiri::XML(xml)

    doc.xpath('/xmlns:InstantiateVAppTemplateParams/@name').text.should == "SomeVAppTemplateParams"
    doc.xpath('/xmlns:InstantiateVAppTemplateParams/@deploy').text.should == "false"
    doc.xpath('/xmlns:InstantiateVAppTemplateParams/@powerOn').text.should == 'true'
    doc.xpath('/xmlns:InstantiateVAppTemplateParams/xmlns:Description').text.should == 'some descriptive string'
    doc.xpath('/xmlns:InstantiateVAppTemplateParams/xmlns:InstantiationParams/xmlns:NetworkConfigSection').text.should == 'blagow'
    doc.xpath('/xmlns:InstantiateVAppTemplateParams/xmlns:Source/@href').text.should == 'https://vcloud.example.com/api/vAppTemplate/vappTemplate-111'
    doc.xpath('/xmlns:InstantiateVAppTemplateParams/xmlns:IsSourceDelete').text.should == 'true'
    doc.xpath('/xmlns:InstantiateVAppTemplateParams/xmlns:AllEULAsAccepted').text.should == 'true'
  end   
end