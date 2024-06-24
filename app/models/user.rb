class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :relationships, dependent: :destroy
  has_many :followings, through: :relationships, source: :follower
  has_many :passive_relationships, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :user
  has_many :user_rooms, dependent: :destroy
  has_many :chats, dependent: :destroy
  has_many :rooms, through: :user_rooms, dependent: :destroy
  has_many :active_notifications, class_name: "Notification", foreign_key: "visitor_id", dependent: :destroy
  has_many :passive_notifications, class_name: "Notification", foreign_key: "visited_id", dependent: :destroy

  has_one_attached :profile_image

  validates :name, presence: true
  validates :account_id, presence: true
  validates :phone_number, presence: true
  validates :email, presence: true
  validates :introduction, length: { maximum: 50 }

  def get_profile_image
    (profile_image.attached?) ? profile_image : 'default-image.jpg'
  end

  #既にフォローしているか
  def following?(user)
    followings.include?(user)
  end

  #フォローを保存する
  def follow(user_id)
    relationships.create(follower: user_id)
  end

  #フォローの解除
  def unfollow(relationship_id)
    relationships.find(relationship_id).destroy!
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

   # フォロー通知を作成するメソッド
  def create_notification_follow!(current_user)

    # すでにフォロー通知が存在するか検索
    existing_notification = Notification.find_by(visitor_id: current_user.id, visited_id: self.id, action: 'follow')

    # フォロー通知が存在しない場合のみ、通知レコードを作成
    if existing_notification.blank?
      notification = current_user.active_notifications.build(
        visited_id: self.id,
        action: 'follow'
      )
      notification.save if notification.valid?
    end
  end

  def self.guest
    find_or_create_by!(email: 'guest1@example.com') do |user|
      user.password = SecureRandom.urlsafe_base65
      user.name = "ゲスト"
      user.account_id = "@guest"
      user.phone_number = "09000000000"
      # user.confirmed_at = Time.now  # Confirmable を使用している場合は必要
      # 例えば name を入力必須としているならば， user.name = "ゲスト" なども必要
    end
  end

  def guest?
    account_id == "@guest"
  end

  #退会ユーザーはログインできなくする
  def active_for_authentication?
    super && (is_active == true)
  end
end
