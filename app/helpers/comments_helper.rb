module CommentsHelper
  def format_comment(text)
    return "" if text.blank?

    text.gsub(/@(\w+)/) do |match|
      username = Regexp.last_match(1)
      user = User.find_by(username: username)

      if user
        uid_or_id = user.respond_to?(:uid) && user.uid.present? ? user.uid : user.id
        "<a href='#{Rails.application.routes.url_helpers.user_path(uid_or_id)}' class='text-blue-600 hover:underline'>@#{username}</a>"
      else
        match
      end
    end.html_safe
  end
end
