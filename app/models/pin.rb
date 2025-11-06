class Pin < ApplicationRecord
    has_one_attached :image


    belongs_to :user
    has_many :comments, dependent: :destroy
    has_many :likes, dependent: :destroy
    has_many :reposts, dependent: :destroy
    has_many :likers, through: :likes, source: :user
    has_many :reposters, through: :reposts, source: :user

    # Validations
    validates :title, presence: true
    validates :image, presence: true

    scope :recent, -> { order(created_at: :desc) }

     # Helper methods
    def likes_count
        likes.count
    end
  
    def comments_count
        comments.count
    end
  
    def reposts_count
        reposts.count
    end
end
