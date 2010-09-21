require 'test/unit'
require 'shoulda'
require 'active_model'
require './lib/loose_change'
require 'timecop'

# Thanks to Larry Marburger
module Test::Unit::Assertions
  def assert_times_close(expected_time, actual_time, message = '')
    assert_in_delta expected_time, actual_time, 0.01, message
  end
end
