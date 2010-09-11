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
  end

  module AttributeClassMethods
    def attributes
      (self.class.properties || []).inject({}) {|acc, key| acc[key] = send(key); acc}
    end
    
    private

    def apply_defaults
      (self.class.defaults || {}).each do |property, value|
        self.send("#{property}=", self.send(property) || value)
      end
    end
  end
  
end
