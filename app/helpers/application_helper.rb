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

    
    unless user&.avatar&.attached?
      return image_tag("default-avatar.png", width: size, height: size, class: css)
    end

    begin
      
      variant = user.avatar.variant(resize_to_fill: [300, 300])

      
      src = rails_representation_path(variant, only_path: true)

      
      alt_text = ERB::Util.html_escape(user.try(:username) || "avatar")
      css_escaped = ERB::Util.html_escape(css)

      return "<img src='#{src}' width='#{size}' height='#{size}' alt='#{alt_text}' class='#{css_escaped}' />".html_safe

    rescue => e
      
      Rails.logger.error "user_avatar error for user=#{user&.id}: #{e.class}: #{e.message}\n#{e.backtrace.first(10).join("\n")}"

      
      return image_tag("default-avatar.png", width: size, height: size, class: css)
    end
  end
end
