module Comments
  class Create
    def self.call(user:, pin:, params:)
      new(user, pin, params).call
    end

    def initialize(user, pin, params)
      @user = user
      @pin = pin
      @params = params
    end

    def call
      comment = pin.comments.build(params)
      comment.user = user

      return comment unless comment.save

      notify_pin_owner(comment)
      notify_parent_comment_owner(comment)
      notify_tagged_users(comment)

      comment
    end

    private

    attr_reader :user, :pin, :params

    def notify_pin_owner(comment)
      return if pin.user_uid == user.uid

      Notification.create!(
        user: pin.user,
        actor: user,
        action: "commented on your post",
        notifiable: comment,
        read: false
      )
    end

    def notify_parent_comment_owner(comment)
      return unless comment.parent_id.present?

      parent_user = comment.parent.user
      return if parent_user.nil?
      return if parent_user.uid == user.uid
      return if parent_user.uid == pin.user_uid

      Notification.create!(
        user: parent_user,
        actor: user,
        action: "replied to your comment",
        notifiable: comment,
        read: false
      )
    end

    def notify_tagged_users(comment)
      pin.tagged_users.each do |tagged|
        next if tagged.id == user.id
        next if tagged.uid == pin.user_uid

        Notification.create!(
          user: tagged,
          actor: user,
          action: "commented on a post you're tagged in",
          notifiable: comment,
          read: false
        )
      end
    end
  end
end
