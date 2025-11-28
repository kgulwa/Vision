class MentionsController < ApplicationController
  before_action :require_login

  def index
    query = params[:q].to_s.downcase

    users = User.where("LOWER(username) LIKE ?", "#{query}%")
                .limit(10)

    results = users.map do |u|
      {
        id: u.respond_to?(:uid) ? u.uid : u.id,
        username: u.username,
        avatar: avatar_url(u)
      }
    end

    render json: results
  end

  private

  def avatar_url(user)
    if user.avatar.attached?
      Rails.application.routes.url_helpers.url_for(user.avatar)
    else
      nil
    end
  end
end
