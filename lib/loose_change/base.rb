module LooseChange
  class Base
    
    include ActiveModel::AttributeMethods
    include ActiveModel::Validations
    include ActiveModel::Serialization
    include ActiveModel::Serializers::JSON
    include ActiveModel::Dirty
    
    # Can't escape the following when trying to
    # use a Callbacks module:
    # undefined method `extlib_inheritable_reader' for LooseChange::Callbacks:Module
    # so we'll throw it in here
    extend ActiveModel::Callbacks
    define_model_callbacks :create, :save, :destroy
    
    extend Attributes
    include AttributeClassMethods
    extend Attachments
    include AttachmentClassMethods
    extend Naming
    include NamingClassMethods
    include Errors
    extend Persistence 
    include PersistenceClassMethods
    extend Views
    extend Validations
    extend Pagination
    extend Spatial
    include Helpers
    extend Helpers
    
    class_inheritable_accessor :database, :properties, :defaults
    attr_accessor :attachments
    
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
      return false unless other_model && other_model.is_a?(self.class)
      id == other_model.id &&
        _rev == other_model._rev &&
        !(changed? || other_model.changed?)
    end
    
    alias_method :eql?, :== 
    
    def hash
      id.try(:hex) || super
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
