require './test/test_helper'

class ViewTest < ActiveSupport::TestCase

  setup do
    LooseChange::Database.delete("test_db")
    
    class ViewModel < LooseChange::Base
      use_database "test_db"
      property :name
      
      view_by :name
    end
    
    @model_one = ViewModel.new(:name => "Josh")
    @model_two = ViewModel.new(:name => "John")
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
  
end
