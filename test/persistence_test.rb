require './test/test_helper'

class PersistenceTest < ActiveSupport::TestCase

  class TestModel < LooseChange::Base
    use_database "http://127.0.0.1:5984", "test_db"
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

  should "be gettable" do
    @model.save
    @retrieved = TestModel.find(@model.id)
    assert_equal [@model.id, @model.name, @model.age], [@retrieved.id, @retrieved.name, @retrieved.age]
  end

  should "be saveable after get" do
    @model.save
    @model.age = 18
    assert @model.save
    @retrieved = TestModel.find(@model.id)
    assert_equal [@model.id, @model.name, @model.age], [@retrieved.id, @retrieved.name, @retrieved.age]
  end
  
  should "be deletable" do
    @model.save
    @model.destroy
    assert @model.destroyed?
    assert_raise LooseChange::RecordNotFound do
      TestModel.find(@model.id)
    end
  end
  
end
