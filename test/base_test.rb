require './test/test_helper'

class BaseTest < ActiveModel::TestCase
  
  include ActiveModel::Lint::Tests

  class CompliantModel < LooseChange::Base
    use_database "test_db"
  end
    
  setup do
    @model = CompliantModel.new
  end
  
  should 'be appropriately equal' do
    @model.save
    assert_equal @model, CompliantModel.find(@model.id)
  end
    
end

