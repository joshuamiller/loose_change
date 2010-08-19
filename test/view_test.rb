require './test/test_helper'

class ViewTest < ActiveSupport::TestCase

  setup do
    LooseChange::Database.delete("http://127.0.0.1:5984", "test_db")
    
    class ViewModel < LooseChange::Base
      use_database "http://127.0.0.1:5984", "test_db"
      property :name
      
      view_by :name
    end
    
    @model_one = ViewModel.new(:name => "Josh")
    @model_two = ViewModel.new(:name => "John")
    @model_one.save
    @model_two.save
  end

  should "be findable based on a view" do
    ViewModel.all
    result = ViewModel.by_name("Josh").first
    assert_equal "Josh", result.name
  end
  
end
