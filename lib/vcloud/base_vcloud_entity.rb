module VCloud
  class BaseVCloudEntity  
    include RestApi

    def self.inherited(base)
      base.class_variable_set(:@@initialize_args, Set.new)
    end
            
    def initialize(params = {})
      initialize_args.each do |arg|
        self.instance_variable_set("@#{arg}".to_sym, params[arg])
      end
      @type = self.type
    end
    
    def self.type
      self.class_variable_get(:@@content_type)
    end

    def self.from_reference(ref, session = VCloud::Session.current_session)
      obj = new({:href => ref.href})
      obj.refresh 
      obj
    end
    
    def self.attr_reader *args
      super *args
      args.each { |arg| self.class_variable_get(:@@initialize_args) << arg }
    end
    
    def self.attr_writer *args
      super *args
      args.each { |arg| self.class_variable_get(:@@initialize_args) << arg }
    end
    
    def self.attr_accessor *args
      super *args
      args.each { |arg| self.class_variable_get(:@@initialize_args) << arg }
    end 
    
    private
    
    def self.has_type(type)
      self.class_variable_set(:@@content_type, type)
    end
    
    def initialize_args
      self.class.class_variable_get(:@@initialize_args)
    end
  end
end