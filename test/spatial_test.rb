require './test/test_helper'

class SpatialTest < ActiveSupport::TestCase

  setup do
    LooseChange::Database.delete("test_db")
  end
  
  context "a basic spatial model with a point" do
    
    setup do
      class PointModel < LooseChange::Base
        use_database "test_db"
        geo_point :loc
      end
      
      @model = PointModel.new(:loc => [40.813874, 77.858219])
      @model.save
    end
    
    should "have a lat,lng pair as a location" do
      assert_equal [40.813874, 77.858219], @model.loc
    end
    
    should "be findable in a bounding box" do
      assert_equal [@model], PointModel.by_bounding_box(:loc, 0, 0, 41, 80)
    end

  end
  
  context "a spatial model with a multipoint" do
    setup do
      class MPModel < LooseChange::Base
        use_database "test_db"
        geo_multipoint :loc
      end
      
      @model = MPModel.new(:loc => [[40.813874, 77.858219], [42.134, 79.23434]])
      @model.save
    end

    should "return its multipoint data" do
      assert_equal [[40.813874, 77.858219], [42.134, 79.23434]], @model.loc
    end
    
    should "be findable in a bounding box" do
      assert_equal [@model], MPModel.by_bounding_box(:loc, 0, 0, 43, 80)
      assert_equal [], MPModel.by_bounding_box(:loc, 0, 0, 40, 80)
    end
  
  end
  
end

