module LooseChange
  class Base

    def to_key
      persisted? ? [id] : nil
    end
    
    def to_model
      self
    end

    def to_param
      to_key ? to_key.join('-') : nil
    end
        
    def persisted?
      false
    end
        
    include ActiveModel::AttributeMethods
    include ActiveModel::Validations

    include Errors

    extend Attributes
    extend Callbacks
    extend Dirty
    extend Validations
    extend Naming
    extend Observer
    extend I18n

  end
end
