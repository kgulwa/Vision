require "rails_helper"

RSpec.describe ApplicationController, type: :controller do
  # Create a controller that inherits from ApplicationController
  controller(ApplicationController) do
    before_action :require_login, only: :protected_action

    def protected_action
      render plain: "OK"
    end

    def public_action
      render plain: "Public"
    end
  end

  # Inject routes so RSpec can call the actions
  before do
    routes.draw do
      get "protected_action" => "anonymous#protected_action"
      get "public_action" => "anonymous#public_action"
      get "login" => "sessions#new"
    end
  end

  let(:user) do
    User.create!(
      username: "tester",
      email: "test@example.com",
      password: "password"
    )
  end

  describe "#current_user" do
    it "returns the user when session contains user_id" do
      session[:user_id] = user.id
      expect(controller.send(:current_user)).to eq(user)
    end

    it "returns nil when session has no user_id" do
      session[:user_id] = nil
      expect(controller.send(:current_user)).to be_nil
    end
  end

  describe "#logged_in?" do
    it "returns true when a user is logged in" do
      session[:user_id] = user.id
      expect(controller.send(:logged_in?)).to eq(true)
    end

    it "returns false when no user is logged in" do
      session[:user_id] = nil
      expect(controller.send(:logged_in?)).to eq(false)
    end
  end

  describe "#require_login" do
    context "when user is not logged in" do
      it "redirects to login_path with alert" do
        get :protected_action
        expect(response).to redirect_to(login_path)
        expect(flash[:alert]).to eq("You must be logged in to access this page.")
      end
    end

    context "when user is logged in" do
      it "allows access to the action" do
        session[:user_id] = user.id
        get :protected_action
        expect(response.body).to eq("OK")
      end
    end
  end
end
