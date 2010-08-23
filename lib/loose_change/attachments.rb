module LooseChange
  
  module Attachments
    def attachment(name)
      attr_accessor name.to_sym, "_#{name}_content_type".to_sym
      self.attachments = ((self.attachments || []) << name.to_sym)
      define_method(name.to_sym) do
        instance_variable_get("@#{name}") || retrieve_attachment(name)
      end
    end
  end

  module AttachmentClassMethods
    def attach(name, file, args = {})
      self.send("#{name}=".to_sym, file)
      self.send("_#{name}_content_type=".to_sym, args[:content_type])
    end
    
    def retrieve_attachment(name)
      RestClient.get("#{ uri }/#{ name }")
    end
    
  end
  
end
