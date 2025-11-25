require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  let(:user) { User.create!(username: 'testuser', email: 'test@example.com', password: 'password123') }

  describe "POST /login" do
    context "with valid credentials" do
      it "logs in the user and redirects to pins" do
        post login_path, params: { username: user.username, password: 'password123' }
        
        expect(response).to redirect_to(pins_path)   
        expect(session[:user_id]).to eq(user.id)
        follow_redirect!
        expect(response.body).to include("Welcome back, #{user.username}")
      end
    end

    context "with invalid username" do
      it "does not log in and shows error message" do
        post login_path, params: { username: 'wronguser', password: 'password123' }
        
        expect(response).to have_http_status(:unprocessable_content)
        expect(session[:user_id]).to be_nil
        expect(response.body).to include("Invalid username or password")
      end
    end

    context "with invalid password" do
      it "does not log in and shows error message" do
        post login_path, params: { username: user.username, password: 'wrongpassword' }
        
        expect(response).to have_http_status(:unprocessable_content)
        expect(session[:user_id]).to be_nil
        expect(response.body).to include("Invalid username or password")
      end
    end
  end

  describe "DELETE /logout" do
    before do
      post login_path, params: { username: user.username, password: 'password123' }
    end

    it "logs out the user and redirects to pins" do
      delete logout_path
      
      expect(response).to redirect_to(pins_path)   
      expect(session[:user_id]).to be_nil
    end
  end
end
