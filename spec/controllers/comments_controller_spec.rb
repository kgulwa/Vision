require "rails_helper"

RSpec.describe CommentsController, type: :request do
  let(:user) { create(:user) }
  let(:pin)  { create(:pin, user: user) }  

  before do
    post login_path, params: { username: user.username, password: "password" }
    follow_redirect!
  end

  it "creates a comment" do
    expect {
      post pin_comments_path(pin),
        params: { comment: { content: "Hello", parent_id: nil } }
    }.to change { Comment.count }.by(1)
  end

  it "deletes a comment" do
    comment = create(:comment, pin: pin, user: user)  

    expect {
      delete pin_comment_path(pin, comment)
    }.to change { Comment.count }.by(-1)
  end
end
