require 'rails_helper'

RSpec.describe User, type: :model do
  it "is invalid without an email_address" do
    user = User.new(email_address: nil, password: "password123")
    expect(user).not_to be_valid
    expect(user.errors[:email_address]).to include("can't be blank")
  end

  it { should validate_presence_of(:password) }
  #it { should have_many(:deeds) } #TO-FIX
  it { should have_many(:sessions) }
  it { should have_many(:daily_logs) }
end
