require "application_system_test_case"

class DailylogsTest < ApplicationSystemTestCase
  setup do
    @dailylog = dailylogs(:one)
  end

  test "visiting the index" do
    visit dailylogs_url
    assert_selector "h1", text: "Dailylogs"
  end

  test "should create dailylog" do
    visit dailylogs_url
    click_on "New dailylog"

    click_on "Create Dailylog"

    assert_text "Dailylog was successfully created"
    click_on "Back"
  end

  test "should update Dailylog" do
    visit dailylog_url(@dailylog)
    click_on "Edit this dailylog", match: :first

    click_on "Update Dailylog"

    assert_text "Dailylog was successfully updated"
    click_on "Back"
  end

  test "should destroy Dailylog" do
    visit dailylog_url(@dailylog)
    click_on "Destroy this dailylog", match: :first

    assert_text "Dailylog was successfully destroyed"
  end
end
