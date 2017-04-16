require "spec_helper"

describe Api::V1::SessionsController do
  default_version 1

  describe "#create" do
    it "returns the token on success" do
      controller.stub(:current_user) { nil }
      user = create(:user)

      post :create, user: { email: user.email, password: user.password }
      expect(response.status).to eq 200
      expect(parsed_response["token"]).to eq user.auth_tokens.first.token
      expect(parsed_response["user_id"]).to eq user.id
    end

    it "cleans up my old tokens" do
      controller.stub(:current_user) { nil }
      user = create(:user)
      create(:auth_token, user: user, token: "old-token", updated_at: 15.days.ago)

      expect(user.reload.auth_tokens.map(&:token)).to include("old-token")

      post :create, user: { email: user.email, password: user.password }
      expect(parsed_response["token"]).to eq user.reload.auth_tokens.first.token

      expect(user.reload.auth_tokens.count).to eq 1
      expect(user.reload.auth_tokens.map(&:token)).to_not include("old-token")
    end

    it "fails if password incorrect" do
      controller.stub(:current_user) { nil }
      user = create(:user)

      post :create, user: { email: user.email, password: "incorrect PW" }
      expect(response).to be_api_error RocketPants::Unauthenticated
    end

    it "fails if email incorrect" do
      controller.stub(:current_user) { nil }
      user = create(:user)

      post :create, user: { email: "wrong@ex.com", password: user.password }
      expect(response).to be_api_error RocketPants::Unauthenticated
    end
  end
end
