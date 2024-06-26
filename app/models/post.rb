class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :notifications, dependent: :destroy

  has_one_attached :image

  validates :body, presence: true, length: { maximum: 200 }

  enum genre: { shine: 0, dark: 1 }

  def post_image(width, height)
    image.variant(resize_to_limit: [width, height]).processed
  end

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  #投稿内容検索
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

  def self.liked_posts(user) # 1. モデル内での操作を開始
  includes(:favorites) # 2. post_favorites テーブルを結合
    .where(favorites: { user_id: user.id }) # 3. ユーザーがいいねしたレコードを絞り込み
    .order(created_at: :desc) # 4. 投稿を作成日時の降順でソート
  end

  # postへのいいね通知機能
  def create_notification_favorite_post!(current_user)
    # 同じユーザーが同じ投稿に既にいいねしていないかを確認
    existing_notification = Notification.find_by(post_id: self.id, visitor_id: current_user.id, action: "favorite_post")

    # すでにいいねされていない場合のみ通知レコードを作成
    if existing_notification.nil? && current_user != self.user
        notification = Notification.new(
        post_id: self.id,
        visitor_id: current_user.id,
        visited_id: self.user.id,
        action: "favorite_post"
      )

      if notification.valid?
        notification.save
      end
    end
  end
  
  # コメントが投稿された際に通知を作成するメソッド
  def create_notification_comment!(current_user, comment_id)
    # 自分以外にコメントしている人をすべて取得し、全員に通知を送る
    other_commenters_ids = Comment.select(:user_id).where(post_id: id).where.not(user_id: current_user.id).distinct.pluck(:user_id)

     # 各コメントユーザーに対して通知を作成
    other_commenters_ids.each do |commenter_id|
      save_notification_comment!(current_user, comment_id, commenter_id)
    end

    # まだ誰もコメントしていない場合は、投稿者に通知を送る
    save_notification_comment!(current_user, comment_id, user_id) if other_commenters_ids.blank?
  end

  # 通知を保存するメソッド
  def save_notification_comment!(current_user, comment_id, visited_id)
    notification = current_user.active_notifications.build(
      post_id: id,
      comment_id: comment_id,
      visited_id: visited_id,
      action: 'comment'
    )

    # 自分の投稿に対するコメントの場合は、通知済みとする
    notification.is_checked = true if notification.visitor_id == notification.visited_id

    # 通知を保存（バリデーションが成功する場合のみ）
    notification.save if notification.valid?
  end
end
