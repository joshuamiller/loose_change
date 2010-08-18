module LooseChange
  module Attributes
    def property(name)
      attr_accessor name.to_sym
      define_attribute_methods([name])
    end
  end
end
