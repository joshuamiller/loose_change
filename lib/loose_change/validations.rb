module LooseChange
  module Validations

    # Ensure that only one document of this class can be created with
    # each value.  The <tt>:allow_nil</tt> option can be set to true
    # to allow any number of documents with a blank value for this property.
    def validates_uniqueness_of(property, opts = {})
      view_by property
      validates_with UniquenessValidator, :property => property, :allow_nil => opts[:allow_nil]
    end

    class UniquenessValidator < ActiveModel::Validator
      
      def validate(record)
        record.errors[@options[:property]] << "must be present" unless record.send(@options[:property]) || @options[:allow_nil]
        record.errors[@options[:property]] << "is already taken" if record.send(@options[:property]).present? && duplicate_exists?(record)
      end

      private

      def duplicate_exists?(record)
        record.class.send(:view, "by_#{ @options[:property] }", :key => record.send(@options[:property]), :limit => 1).size > 0
      end
                            
    end
     
  end
end
