require './test/test_helper'

class ViewTest < ActiveSupport::TestCase

  setup do
    LooseChange::Database.delete("test_db")
    
    class ViewModel < LooseChange::Base
      use_database "test_db"
      property :name
      property :age
      
      view_by :name
      view_by :name, :age
    end
    
    @model_one = ViewModel.new(:name => "Josh", :age => 20)
    @model_two = ViewModel.new(:name => "John", :age => 20)
    @model_one.save
    @model_two.save
  end

  should "be findable as all" do
    assert_equal 2, ViewModel.all.size
  end
  
  should "be findable based on a view" do
    result = ViewModel.by_name("Josh").first
    assert_equal "Josh", result.name
  end

  should "be findable with multiple keys" do
    results = ViewModel.by_name_and_age "Josh", 20
    assert_equal 1, results.length
    assert_equal "Josh", results.first.name
  end
  
end
