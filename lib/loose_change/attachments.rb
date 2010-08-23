module LooseChange
  
  module Attachments
    def attachment(name)
      attr_accessor name.to_sym, "_#{name}_content_type".to_sym
      self.attachments = ((self.attachments || []) << name.to_sym)
    end
  end
  
end
