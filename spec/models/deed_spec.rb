require 'rails_helper'

RSpec.describe Deed, type: :model do
  let(:user) { create(:user) }
  let(:deed) { build(:deed, user_id: user.id) }

  it { should belong_to(:user) }
  it { should validate_presence_of(:title) }
  it { is_expected.not_to validate_presence_of(:total_time)}

  describe "completed?" do
    context 'default value finished' do
      let(:deed) { build(:deed, user_id: user.id) }

      it "has a default finished value of false" do
        expect(deed.finished?).to be_falsey
      end
    end

    context "when the deed is finished" do
      let(:deed) { create(:deed, user_id: user.id, finished: true) }

      it "returns true when the deed is finished" do
        expect(deed.finished?).to be true
      end
    end
  end
end
