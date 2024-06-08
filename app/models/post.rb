class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  enum genre: { shine: 0, dark: 1 }

  def post_image(width, height)
    image.variant(resize_to_limit: [width, height]).processed
  end
end
