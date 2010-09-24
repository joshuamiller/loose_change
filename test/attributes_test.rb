require './test/test_helper'

class AttributesTest < ActiveSupport::TestCase

  setup do
    class AttributesModel < LooseChange::Base
      property :age
      property :name
    end

    @model = AttributesModel.new
  end

  should 'allow attributes to updated' do
    @model.update_attributes(:age => 1, :name => "John")
    assert_equal 1, @model.age
  end
    
end
