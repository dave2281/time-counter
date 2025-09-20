require "test_helper"

class DailylogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @dailylog = dailylogs(:one)
  end

  test "should get index" do
    get dailylogs_url
    assert_response :success
  end

  test "should get new" do
    get new_dailylog_url
    assert_response :success
  end

  test "should create dailylog" do
    assert_difference("Dailylog.count") do
      post dailylogs_url, params: { dailylog: {} }
    end

    assert_redirected_to dailylog_url(Dailylog.last)
  end

  test "should show dailylog" do
    get dailylog_url(@dailylog)
    assert_response :success
  end

  test "should get edit" do
    get edit_dailylog_url(@dailylog)
    assert_response :success
  end

  test "should update dailylog" do
    patch dailylog_url(@dailylog), params: { dailylog: {} }
    assert_redirected_to dailylog_url(@dailylog)
  end

  test "should destroy dailylog" do
    assert_difference("Dailylog.count", -1) do
      delete dailylog_url(@dailylog)
    end

    assert_redirected_to dailylogs_url
  end
end
