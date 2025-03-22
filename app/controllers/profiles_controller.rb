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
    if profile_params[:avatar].present?
      @profile.avatar.attach(profile_params[:avatar])
    end

    # その他のパラメータの更新
    if @profile.update(profile_params.except(:avatar))
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
