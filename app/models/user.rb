class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_one_attached :header_image
  has_one_attached :profile_image

  def get_profile_image
    (profile_image.attached?) ? profile_image : 'default-image.jpg'
  end

  def get_header_image
    header_image.variant(resize_to_limit: [width, height]).processed
  end
end