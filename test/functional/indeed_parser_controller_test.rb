require 'test_helper'

class IndeedParserControllerTest < ActionController::TestCase
  test "should get parse" do
    get :parse
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

end
