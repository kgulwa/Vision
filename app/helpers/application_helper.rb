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

    
    return image_tag("default-avatar.png", width: size, height: size, class: css) unless user&.avatar&.attached?

    begin
      
      variant = user.avatar.variant(resize_to_fill: [size, size]).processed

      
      return image_tag(url_for(variant), width: size, height: size, class: css)

    rescue => e
      Rails.logger.error("user_avatar error for user=#{user.id}: #{e.message}")

      
      return image_tag("default-avatar.png", width: size, height: size, class: css)
    end
  end

end
