require './test/test_helper'

class SpatialTest < ActiveSupport::TestCase

  setup do
    LooseChange::Database.delete("test_db")

    class SpatialModel < LooseChange::Base
      use_database "test_db"
      geo_point :loc
    end
  end
  
  context "a basic spatial model with a point" do
    
    setup do
      @model = SpatialModel.new(:loc => [40.813874, 77.858219])
      @model.save
    end
    
    should "have a lat,lng pair as a location" do
      assert_equal [40.813874, 77.858219], @model.loc
    end
    
    should "be findable in a bounding box" do
      assert_equal [@model], SpatialModel.by_bounding_box(0,0,41,80)
    end

  end

end

