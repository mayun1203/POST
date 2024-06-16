class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_one_attached :header_image
  has_one_attached :profile_image

  validates :name, presence: true
  validates :account_id, presence: true
  validates :phone_number, presence: true
  validates :email, presence: true
  validates :introduction, length: { maximum: 50 }
  #validates :body, presence: true, length: { maximum: 200 }

  def get_profile_image
    (profile_image.attached?) ? profile_image : 'default-image.jpg'
  end

  def get_header_image
    header_image.variant(resize_to_limit: [width, height]).processed
  end

  #退会ユーザーはログインできなくする
  def active_for_authentication?
    super && (is_active == true)
  end
end
