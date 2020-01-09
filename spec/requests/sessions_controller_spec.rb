require 'rails_helper'

RSpec.describe "SessionsController", type: :request do
  describe "GET #new" do
    it "returns http success" do
      get login_path
      expect(response).to have_http_status 200
    end
  end
end