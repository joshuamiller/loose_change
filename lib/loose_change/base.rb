module LooseChange
  class Base
    
    include ActiveModel::AttributeMethods
    include ActiveModel::Validations
    include ActiveModel::Serialization
    include ActiveModel::Serializers::JSON
    
    extend Attributes
    include AttributeClassMethods
    extend Callbacks
    extend Dirty
    extend Validations
    extend Naming
    include NamingClassMethods
    include Errors
    extend Observer
    extend I18n
    extend Persistence 
    include PersistenceClassMethods
    
    cattr_accessor :database, :properties
    
    def self.use_database(server, db)
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
        
    def initialize(args = {})
      @errors = ActiveModel::Errors.new(self)
      @database = @@database
      @new_record = true
      args.each {|property, value| self.send("#{property}=".to_sym, value)}
    end
    
  end
end

LooseChange::Base.include_root_in_json = false
