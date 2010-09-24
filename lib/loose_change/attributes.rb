module LooseChange
  
  module Attributes
    def property(name, opts = {})
      attr_accessor name.to_sym
      self.properties = ((self.properties || []) << name.to_sym)
      default(name.to_sym, opts[:default]) if opts[:default]
      define_attribute_methods [name]
    end

    def default(property, value)
      self.defaults ||= {}
      self.defaults[property] = value
    end
    
    def timestamps!
      property :created_at
      property :updated_at
      
      before_create :touch_created_at
      before_create :touch_updated_at
      before_save :touch_updated_at
    end
  end

  module AttributeClassMethods
    def attributes
      (self.class.properties || []).inject({}) {|acc, key| acc[key] = send(key); acc}
    end
    
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
