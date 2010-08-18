require './test/test_helper'

class PersistenceTest < ActiveSupport::TestCase

  class TestModel < LooseChange::Base
    database "http://127.0.0.1:5984", "test_db"
    property :name
    property :age
  end
    
  setup do
    @model = TestModel.new
    @model.name = "Test"
  end

  should "not be persisted until saved" do
    assert !@model.persisted?
  end

  should "be saveable" do
    @model.save
    assert @model.persisted?
    assert_not_nil @model.id
  end
    
end
