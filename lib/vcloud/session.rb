module VCloud
  module Session
    
    def self.set_session(client)
      @@current_session = client
    end
    
    def current_session
      @@current_session
    end
      
    def self.current_session
      @@current_session
    end
    
  end
end