require "test_helper"

class DeedsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @deed = deeds(:one)
  end

  test "should get index" do
    get deeds_url
    assert_response :success
  end

  test "should get new" do
    get new_deed_url
    assert_response :success
  end

  test "should create deed" do
    assert_difference("Deed.count") do
      post deeds_url, params: { deed: {} }
    end

    assert_redirected_to deed_url(Deed.last)
  end

  test "should show deed" do
    get deed_url(@deed)
    assert_response :success
  end

  test "should get edit" do
    get edit_deed_url(@deed)
    assert_response :success
  end

  test "should update deed" do
    patch deed_url(@deed), params: { deed: {} }
    assert_redirected_to deed_url(@deed)
  end

  test "should destroy deed" do
    assert_difference("Deed.count", -1) do
      delete deed_url(@deed)
    end

    assert_redirected_to deeds_url
  end
end
