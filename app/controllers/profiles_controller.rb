class ProfilesController < ApplicationController
  before_action :authenticate_user!, only: [ :edit, :update ]
  before_action :set_profile
  before_action :ensure_correct_user, only: [ :edit, :update ]

  def show
    @posts = @profile.user.posts  # プロフィールページでその人の投稿一覧も表示
  end

  def edit
  end

  def update
    @profile = Profile.find(params[:id])
    @profile.assign_attributes(profile_params.except(:avatar))

    if profile_params[:avatar].present?
      avatar = profile_params[:avatar]

      unless avatar.content_type == "image/png"
        @profile.errors.add(:avatar, "はPNG形式のみ許可されています")
        render :edit, status: :unprocessable_entity
        return # 処理を中断
      end

      avatar.rewind if avatar.respond_to?(:rewind)

      blob = ActiveStorage::Blob.create_and_upload!(
        io: avatar,
        filename: "#{Time.current.to_i}_#{SecureRandom.hex(4)}.webp",
        content_type: "image/webp"
        )

      @profile.avatar.attach(blob)
    end

    # その他のパラメータの更新
    if @profile.save
      redirect_to profile_path(@profile), notice: "プロフィールを更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_profile
    @profile = Profile.find(params[:id])
  end

  def profile_params
    params.require(:profile).permit(:nickname, :description, :avatar)
  end

  def ensure_correct_user
    unless @profile.user == current_user
      redirect_to root_path, alert: "権限がありません"
    end
  end
end
