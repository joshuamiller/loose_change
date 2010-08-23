module LooseChange
  
  module Attributes
    def property(name)
      attr_accessor name.to_sym
      self.properties = ((self.properties || []) << name.to_sym)
      define_attribute_methods [name]
    end
  end

  module AttributeClassMethods
    def attributes
      (self.class.properties || []).inject({}) {|acc, key| acc[key] = send(key); acc}
    end
  end
  
end
