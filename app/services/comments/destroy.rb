module Comments
  class Destroy
    def self.call(comment:, user:)
      return unless comment && comment.user == user
      comment.destroy
    end
  end
end
