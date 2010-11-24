module LooseChange
  
  module Attributes
    
    # Set a field to be stored in a CouchDB document.  Any
    # JSON-encodable value can be used; there is no explicit typing.
    # The <tt>:default</tt> option can be used to always store a value
    # on documents where this property has not been set.
    #
    #   class Recipe < LooseChange::Base
    #     property :name
    #     property :popularity, :default => 0
    #   end
    def property(name, opts = {})
      attr_accessor name.to_sym
      self.properties = ((self.properties || []) << name.to_sym)
      default(name.to_sym, opts[:default]) if opts[:default]
      define_attribute_methods [name]
    end
    
    #:nodoc:
    def default(property, value)
      self.defaults ||= {}
      self.defaults[property] = value
    end

    # Automatically set up <tt>:created_at</tt> and
    # <tt>:updated_at</tt> properties which are set on creation and
    # save, respectively.
    def timestamps!
      property :created_at
      property :updated_at
      
      before_create :touch_created_at
      before_create :touch_updated_at
      before_save :touch_updated_at
    end
  end

  module AttributeClassMethods

    # Returns a hash of property names and current values.
    def attributes
      (self.class.properties || []).inject({}) {|acc, key| acc[key] = send(key); acc}
    end
    
    # Change the value of a property and save the result to CouchDB.
    def update_attribute(name, value)
      send("#{name}=", value)
      save
    end
    
    # Change multiple properties at once with a hash of property names
    # and values, then save the result to CouchDB.
    def update_attributes(args = {})
      args.each do |name, value|
        send("#{name}=", value)
      end
      save
    end
    
    private
    
    def touch_created_at
      self.created_at = Time.now
    end

    def touch_updated_at
      self.updated_at = Time.now
    end
        
    def apply_defaults
      (self.class.defaults || {}).each do |property, value|
        self.send("#{property}=", self.send(property) || value)
      end
    end
  end
  
end
