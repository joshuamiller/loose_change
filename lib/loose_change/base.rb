module LooseChange
  class Base
    
    include ActiveModel::AttributeMethods
    include ActiveModel::Validations
    include ActiveModel::Serialization
    include ActiveModel::Serializers::JSON
    
    # Can't escape the following when trying to
    # use a Callbacks module:
    # undefined method `extlib_inheritable_reader' for LooseChange::Callbacks:Module
    #
    # so we'll throw it in here
    # include Callbacks
    extend ActiveModel::Callbacks
    define_model_callbacks :create, :save, :destroy
    
    extend Attributes
    include AttributeClassMethods
    extend Attachments
    include AttachmentClassMethods
    extend Dirty
    extend Validations
    extend Naming
    include NamingClassMethods
    include Errors
    extend Observer
    extend I18n
    extend Persistence 
    include PersistenceClassMethods
    extend Views
    
    include Helpers
    extend Helpers
    
    class_attribute :database, :properties, :defaults, :attachments
    
    def to_key
      persisted? ? [id] : nil
    end
    
    def to_model
      self
    end

    def to_param
      (to_key && persisted?) ? to_key.join('-') : nil
    end
        
    def ==(other_model)
      id == other_model.id &&
        _rev == other_model._rev
    end
          
    def initialize(args = {})
      @errors = ActiveModel::Errors.new(self)
      @database = self.database
      @new_record = true unless args['_id']
      args.each {|property, value| self.send("#{property}=".to_sym, value)}
      apply_defaults
      self
    end
    
  end
end

LooseChange::Base.include_root_in_json = false
