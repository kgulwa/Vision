module CommentsHelper
  def format_comment(text)
    return "" if text.blank?

    # Convert @username into clickable profile links
    text.gsub(/@(\w+)/) do |match|
      username = Regexp.last_match(1)
      user = User.find_by(username: username)

      if user
        # Link to the user's profile
        "<a href='/users/#{user.id}' class='text-blue-600 hover:underline'>@#{username}</a>"
      else
        match
      end
    end.html_safe
  end
end
