class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, only: [ :show ]
  before_action :authorize_destroy, only: [ :destroy ]

  # GET /posts or /posts.json
  def index
    @q = Post.ransack(params[:q])
    @posts = @q.result(distinct: true).includes(:user)
  end

  # GET /posts/1 or /posts/1.json
  def show
    @user = @post.user
    # プロフィールページからの遷移の場合
    if request.referer&.include?("/profiles")
      session[:return_to] = "profile"
    # ホームページからの遷移の場合
    elsif request.referer&.include?("/posts")
      session[:return_to] = "posts"
    end
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params.except(:image))
    @post.user = current_user

    # 画像が添付されている場合の処理
    if params[:post][:image].present?
      image = params[:post][:image]

        image.rewind if image.respond_to?(:rewind)
        # アップロード時にWebPに変換
        blob = ActiveStorage::Blob.create_and_upload!(
          io: image,
          filename: "#{Time.current.to_i}_#{SecureRandom.hex(4)}.webp",
          content_type: "image/webp"
        )
        @post.image.attach(blob)
    end

    respond_to do |format|
      if @post.save
        format.html { redirect_to posts_path, notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy!

    respond_to do |format|
      format.html do
        redirect_url = if session[:return_to] == "profile"
          session.delete(:return_to) # セッションをクリア
          profile_path(current_user.profile)
        else
          session.delete(:return_to) # セッションをクリア
          posts_path
        end

        redirect_to redirect_url, status: :see_other, notice: "Post was successfully destroyed."
      end
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.includes(user: :profile).find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:content, :image)
    end

    def authorize_destroy
      unless current_user.admin? || @post.user == current_user
        redirect_to posts_path, alert: "権限がありません"
      end
    end
end
