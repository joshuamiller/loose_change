module LooseChange
  module Naming
    include ActiveModel::Naming
  end
  
  module NamingClassMethods
    def model_name
      self.class.model_name
    end
  end
end
