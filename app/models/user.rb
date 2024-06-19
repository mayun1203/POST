class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

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

  #ユーザー検索
  def self.looks(search, word)
    if search == "perfect"
      @user = User.where("name LIKE?", "#{word}")
    elsif search == "forward"
      @user = User.where("name LIKE?","#{word}%")
    elsif search == "backward"
      @user = User.where("name LIKE?","%#{word}")
    elsif search == "partial"
      @user = User.where("name LIKE?","%#{word}%")
    else
      @user = User.all
    end
  end



  #退会ユーザーはログインできなくする
  def active_for_authentication?
    super && (is_active == true)
  end
end
