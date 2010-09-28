require './test/test_helper'

class PaginationTest < ActiveSupport::TestCase

  setup do
    class PaginationModel < LooseChange::Base
      use_database "test_db"
    end

    5.times { PaginationModel.create }
  end

  should 'automatically paginate all' do
    assert_equal 4, PaginationModel.paginate(:page => 1, :per_page => 4).size
  end

end

      
