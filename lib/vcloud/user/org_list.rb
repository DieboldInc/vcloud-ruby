module VCloud
  class OrgList
    include HappyMapper
    tag 'OrgList'
    has_many :orgs, OrgReference
  end
end