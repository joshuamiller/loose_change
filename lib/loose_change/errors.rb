module LooseChange
  module Errors
    def errors
      obj = Object.new
      def obj.[](key)         [] end
      def obj.full_messages() [] end
      def obj.clear()         [] end
      def obj.empty?()
        full_messages.empty?
      end
      obj
    end
  end
end
