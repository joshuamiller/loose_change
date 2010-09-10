require './test/test_helper'

class CallbackTest < ActiveSupport::TestCase

  class CallbackModel < LooseChange::Base
    use_database "test_db"
    property :name
    property :age
    before_save :double_age
    after_destroy :create_copy
    
    private
    
    def double_age() self.age = age * 2; end
    def create_copy() CallbackModel.new(:age => age, :name => name).save; end
  end
  
  should 'run callback after destroy' do
    d_model = CallbackModel.new(:age => 10, :name => 'd')
    d_model.save
    d_model.destroy
    assert_equal d_model.name, CallbackModel.all.last.name
  end
  
  should 'run callback before save' do
    model = CallbackModel.new(:age => 10, :name => 's')
    model.save
    retrieved = CallbackModel.find(model.id)
    assert_equal 20, retrieved.age
  end
  
end

        
     
