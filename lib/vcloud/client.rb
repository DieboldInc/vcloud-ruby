module VCloud

  class Client
  
    attr_reader :api_version, :url
        
    def initialize(url, api_version)
      @url = url
      @api_version = api_version
      
      @headers =    
    end
  
    def login(username, password)
      
    end
  
  end

end