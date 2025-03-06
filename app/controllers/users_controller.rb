class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin

  def index
    @users = User.all
  end

  def destroy
    @user = User.find(params[:id])
    if @user == current_user
      redirect_to users_path, alert: "管理者は削除できません"
    else
      @user.destroy
      redirect_to users_path, notice: "ユーザーを削除しました"
    end
  end

  private
  def check_admin
    unless current_user.admin?
      redirect_to root_path, alert: "管理者以外はアクセスできません"
    end
  end
end
