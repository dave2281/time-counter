require "application_system_test_case"

class DeedsTest < ApplicationSystemTestCase
  setup do
    @deed = deeds(:one)
  end

  test "visiting the index" do
    visit deeds_url
    assert_selector "h1", text: "Deeds"
  end

  test "should create deed" do
    visit deeds_url
    click_on "New deed"

    click_on "Create Deed"

    assert_text "Deed was successfully created"
    click_on "Back"
  end

  test "should update Deed" do
    visit deed_url(@deed)
    click_on "Edit this deed", match: :first

    click_on "Update Deed"

    assert_text "Deed was successfully updated"
    click_on "Back"
  end

  test "should destroy Deed" do
    visit deed_url(@deed)
    click_on "Destroy this deed", match: :first

    assert_text "Deed was successfully destroyed"
  end
end
