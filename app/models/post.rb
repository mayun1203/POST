class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_one_attached :image

  validates :body, presence: true, length: { maximum: 200 }

  enum genre: { shine: 0, dark: 1 }

  def post_image(width, height)
    image.variant(resize_to_limit: [width, height]).processed
  end

  #投稿内容
  def self.looks(search, word)
    if search == "perfect"
      @post = Post.where("body LIKE?","#{word}")
    elsif search == "forward"
      @post = Post.where("body LIKE?","#{word}%")
    elsif search == "backward"
      @post = Post.where("body LIKE?","%#{word}")
    elsif search == "partial"
      @post = Post.where("body LIKE?","%#{word}%")
    else
      @post = Post.all
    end
  end


end
