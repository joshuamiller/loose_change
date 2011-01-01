require './test/test_helper'

class ValidationsTest < ActiveSupport::TestCase

  context "a model that validates uniqueness without allow_nil" do
    setup do
      class UniqueModel < LooseChange::Base
        use_database "test_db"
        property :name
        validates_uniqueness_of :name
      end
    end
    
    should "be valid if no others have been created" do
      assert UniqueModel.new(:name => "Josh").valid?
    end

    should "not be valid attempting to create a second" do
      UniqueModel.create(:name => "Josh")
      model = UniqueModel.new(:name => "Josh")
      assert !model.valid?
      assert model.errors.has_key?(:name)
    end

    should "not be valid without a value" do
      model = UniqueModel.new
      assert !model.valid?
      assert model.errors.has_key?(:name)
    end
  end

  context "a model that validates uniqueness with allow_nil as true" do
    setup do
      class AllowNilModel < LooseChange::Base
        use_database "test_db"
        property :name
        validates_uniqueness_of :name, :allow_nil => true
      end
    end

    should "be valid if the property is nil" do
      assert AllowNilModel.create
      model = AllowNilModel.new
      assert model.valid?
    end
  end
  
end
