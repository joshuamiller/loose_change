require './test/test_helper'

class PersistenceTest < ActiveSupport::TestCase

  setup do
    LooseChange::Database.delete "test_db"

    class TestModel < LooseChange::Base
      use_database "test_db"
      property :name, :default => "Jose"
      property :age
      timestamps!
    end
    
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

  should 'update its _rev on multiple saves' do
    @model.save
    assert_not_equal @model._rev, @model.save._rev
  end
    
  should "take save with a !" do
    model = TestModel.new(:age => 2)
    model.save!
    assert model.persisted?
  end

  should "be createable" do
    model = TestModel.create(:age => 2)
    assert model.persisted?
    assert_not_nil model.id
  end
  
  context 'invalid models' do
    class ValidationTestModel < LooseChange::Base
      use_database "test_db"
      property :name, :default => "Jose"
      property :age
      validates_numericality_of :age
      timestamps!
    end

    should "not be saveable" do
      @invalid_model = ValidationTestModel.new(:age => "Too old")
      assert !(@invalid_model.save)
      assert_raises LooseChange::RecordInvalid do
        @invalid_model.save!
      end
    end
    
    should "not be createable" do
      assert !(ValidationTestModel.create(:age => "Too old").valid?)
      assert ValidationTestModel.create(:age => "Too old").id.nil?
      assert_raises LooseChange::RecordInvalid do
        ValidationTestModel.create!(:age => "Too old")
      end
    end
  end

  should "not be saveable if no database set" do
    class DBLessModel < LooseChange::Base
      property :name
    end

    @invalid_model = DBLessModel.new(:name => "Problematic.")
    assert_raises LooseChange::DatabaseNotSet do
      @invalid_model.save
    end
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
  
  should "honor a default" do
    new_model = TestModel.new(:age => 2)
    assert_equal "Jose", new_model.name
  end

  should "accept timestamps" do
    time = Time.now
    Timecop.travel(time)
    new_model = TestModel.new
    new_model.save
    assert_times_close time, new_model.created_at
    assert_times_close time, new_model.updated_at
    future = time + 10.minutes
    Timecop.travel(future)
    new_model.save
    assert_times_close future, new_model.updated_at
    assert_times_close time, new_model.created_at
    Timecop.return
  end
  
end
