require 'rails_helper'

RSpec.describe "ChatPosts", type: :request do

  describe "GET /create" do
    it "returns http success" do
      get "/chat_posts/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/chat_posts/destroy"
      expect(response).to have_http_status(:success)
    end
  end

end
