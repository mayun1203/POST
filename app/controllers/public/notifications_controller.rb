class Public::NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user
    @notices = current_user.passive_notifications.order(created_id: :desc)
    @unchecked_notifications = @notices.where(is_checked: false)

    #確認済みの通知を取得
    @checked_notifications = @notices.where(is_checked: true).limit(20)

    #通知を確認済みに更新
    current_user.passive_notifications.update_all(is_checked: true)
    render partial: "index"
  end

  #通知を一括して確認済みにに
  def update_checked
    current_user.passive_notifications.update_all(is_checked: true)
    head :no_content
  end
end
