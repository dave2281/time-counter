require 'rails_helper'

RSpec.describe "Confirmations", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/confirmations/show"
      expect(response).to have_http_status(:success)
    end
  end

end
