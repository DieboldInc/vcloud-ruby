# Require files in lib/vcloud

module VCloud
  require 'restclient'
  require 'happymapper'
  require 'set'
    
  require 'vcloud/user/link'
       
  require 'vcloud/constants'
  require 'vcloud/session'
  require 'vcloud/parses_xml'
  require 'vcloud/rest_api'
  require 'vcloud/base_vcloud_entity'
  require 'vcloud/client'
  
  require 'vcloud/user'
end