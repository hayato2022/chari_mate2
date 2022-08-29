class Public::PostsController < ApplicationController
  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    # splitメソッドとは文字列を分割して配列にするメソッド
    # 受け取った値を「,」で区切って配列にする
    tag_list = params[:post][:name].split(',')
    if @post.save
      @post.save_tag(tag_list)
      redirect_to post_path(@post.id), notice: '投稿完了しました'
    else
      render :new
    end
  end

  def index
     @tag_list = Tag.all

    if params[:tag_id]
      @tag = Tag.find(params[:tag_id])
      @posts = @tag.posts.all
    else
      @posts = Post.all
    end

  end

  def show
    @post = Post.find(params[:id])
    @post_tags = @post.tags
  end

  def search
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    tag_list = params[:post][:name].split(',')
    if @post.update(post_params)
      @post.save_tag(tag_list)
      redirect_to post_path(@post.id), notice: '編集完了しました'
    else
      render :edit
    end
  end

  def destroy
    @post = Post.find(post_params)
    @post.destroy
    redirect_to posts_path
  end

  private

  def post_params
    params.require(:post).permit(:body, :image, :tag_id)
  end

end
