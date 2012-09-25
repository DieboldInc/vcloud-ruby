module VCloud
  class OrgList
    include HappyMapper
    tag 'OrgList'
    has_many :orgs, Reference, :tag => 'Org'
  end
end