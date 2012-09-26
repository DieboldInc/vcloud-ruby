module VCloud
  class OrgList < BaseVCloudEntity
    include ParsesXml
    has_type VCloud::Constants::ContentType::ORG_LIST
    has_default_attributes
    tag 'OrgList'
    has_many :orgs, 'VCloud::Reference', :tag => 'Org'
  end
end