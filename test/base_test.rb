require './test/test_helper'

class BaseTest < ActiveModel::TestCase
  
  include ActiveModel::Lint::Tests

  class CompliantModel < LooseChange::Base
  end
    
  setup do
    @model = CompliantModel.new
  end
    
end

