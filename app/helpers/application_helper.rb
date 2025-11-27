module ApplicationHelper
  def logged_in?
    session[:user_id].present?
  end

  def current_user
    return @current_user if defined?(@current_user)

    user_id = session[:user_id]
    @current_user = user_id ? User.find_by(id: user_id) : nil
  end

  def user_avatar(user, size: 40, class_name: "")
    css = "rounded-full object-cover #{class_name}".strip

    # If no avatar uploaded, use default
    unless user&.avatar&.attached?
      return image_tag("default-avatar.png", width: size, height: size, class: css)
    end

    begin
      # Resize to square variant
      variant = user.avatar.variant(resize_to_fill: [300, 300])

      # Generate local path (no hostname needed)
      src = rails_representation_path(variant, only_path: true)

      alt_text = ERB::Util.html_escape(user.try(:username) || "avatar")
      css_escaped = ERB::Util.html_escape(css)

      return "<img src='#{src}' width='#{size}' height='#{size}' alt='#{alt_text}' class='#{css_escaped}' />".html_safe

    rescue => e
      Rails.logger.error "user_avatar error for user=#{user&.id}: #{e.class}: #{e.message}\n#{e.backtrace.first(10).join("\n")}"
      return image_tag("default-avatar.png", width: size, height: size, class: css)
    end
  end

  def render_with_mentions(text)
    return "" if text.blank?

    text.gsub(/@(\w+)/) do |mention|
      username = Regexp.last_match(1)
      user = User.find_by(username: username)

      if user
        # clickable blue @mention
        link_to("@#{username}", user_path(user),
          class: "text-blue-600 font-semibold hover:underline")
      else
        mention
      end
    end.html_safe
  end
end
