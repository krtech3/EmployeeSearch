class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :set_ransack

  def index
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to users_url, notice: "ユーザ「#{@user.name}」を登録しました。"
    else
      render :new
    end
  end

  def edit
  end

  def update
    # FIXME: prefix「0」が無視されてしまう問題をformat関数を使って解決せよ
    # @q = User.ransack(params[:q])
    # @user = User.find_by(tel_extention).format('%0d', "#{@user.tel_extention}")
    @user.update!(user_params)
    redirect_to users_url, notice: "ユーザ「#{@user.name}」を更新しました。"
  end

  def destroy
    @user.destroy
    redirect_to users_url, notice: "ユーザ「#{@user.name}」を削除しました。"
  end

  private

  def user_params
    params.require(:user).permit(:emproyee_id, :name, :image, :dept1, :dept2, :dept3, :position_name, :tel_extention, :tel_outside, :tel_mobile, :email, :location_name)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def set_ransack
    # FIXME: あとで「ふりがな」カラムを追加したらこれもソートに含めるよう修正
    @q = User.order(location_name: :asc, name: :asc, dept1: :asc, dept2: :asc, dept3: :asc).ransack(params[:q])
    @users = @q.result(distinct: true).page(params[:page])
  end
end
