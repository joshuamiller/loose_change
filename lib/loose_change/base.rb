module LooseChange
  class Base
    
    include ActiveModel::AttributeMethods
    include ActiveModel::Validations
    include ActiveModel::Serialization
    include ActiveModel::Serializers::JSON
    
    extend Attributes
    include AttributeMethods
    extend Callbacks
    extend Dirty
    extend Validations
    extend Naming
    include Errors
    extend Observer
    extend I18n
    include Persistence
    
    cattr_accessor :properties
    
    def self.database(server, db)
      @@database = Database.new(Server.new(server), db)
    end
    
    def to_key
      persisted? ? [id] : nil
    end
    
    def to_model
      self
    end

    def to_param
      to_key ? to_key.join('-') : nil
    end
        
    def initialize
      @errors = ActiveModel::Errors.new(self)
      @database = @@database
      @new_record = true
    end
    
  end
end
