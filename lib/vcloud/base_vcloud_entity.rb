module VCloud
  # Base class for all vCloud entities (Org, CatalogItem, vApp, etc.)
  class BaseVCloudEntity  
    include RestApi

    def self.inherited(base)
      base.class_variable_set(:@@initialize_args, Set.new)
      base.send(:include, ParsesXml)
      base.class_eval { attr_accessor :session }
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

    # Retrieve an entity from a VCloud::Reference
    #
    # @param [VCloud::Reference] ref Reference to retrieve the entity with
    # @param [VCloud::Client] session Session to authenticate with when retrieving the entity
    # @param [VCloud::BaseVCloudEntity] Entity from vCloud Director
    def self.from_reference(ref, session)
      obj = new(:href => ref.href, :session => session)
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