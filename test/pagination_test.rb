require './test/test_helper'

class PaginationTest < ActiveSupport::TestCase

  setup do
    class PaginationModel < LooseChange::Base
      use_database "test_db"
      property :age
      property :height
      
      paginated_view_by :age
      paginated_view_by :age, :height
    end
    
    PaginationModel.all.each &:destroy
    5.times { PaginationModel.create(:age => 10) }
    5.times { PaginationModel.create(:age => 10, :height => 3) }
  end

  should 'automatically paginate all' do
    assert_equal 4, PaginationModel.paginate(:page => 1, :per_page => 4).size
  end
  
  should 'paginate by properties' do
    assert_equal 3, PaginationModel.paginated_by(:age, :key => 10, :page => 1, :per_page => 3).size
  end

  should 'paginate by multiple properties' do
    assert_equal 1, PaginationModel.paginated_by('age_and_height', :key => [10, 3], :page => 2, :per_page => 4).size
  end
  
  
end

      
