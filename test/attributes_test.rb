require './test/test_helper'

class AttributesTest < ActiveSupport::TestCase

  setup do
    class AttributesModel < LooseChange::Base
      use_database "test_db"

      property :age
      property :name
      validates_numericality_of :age
    end

    @model = AttributesModel.create
  end

  should 'allow attributes to updated' do
    @model.update_attributes(:age => 1, :name => "John")
    assert_equal 1, @model.age
    assert_not_nil @model.id
  end
  
  should 'return false when attempting to update invalid attributes' do
    assert_equal false, @model.update_attributes(:age => "John")
  end
  
end
