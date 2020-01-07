require 'test_helper'

class IndustriesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get industries_index_url
    assert_response :success
  end

  test "should get show" do
    get industries_show_url
    assert_response :success
  end

end
