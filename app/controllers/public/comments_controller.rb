class Public::CommentsController < ApplicationController
  def create
    # コメントをする対象の投稿(post)のインスタンスを作成
    @post = Post.find(params[:post_id])
    #投稿に紐づいたコメントを作成
    @comment = @post.comments.new(comment_params)
    # コメント投稿者(user)のidを代入
    @comment.user_id = current_user.id
    @comment.save
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:comment, :user_id, :post_id)
  end
end
