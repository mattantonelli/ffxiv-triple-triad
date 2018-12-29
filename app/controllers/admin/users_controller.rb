class Admin::UsersController < AdminController
  def index
    @q = User.all.ransack(params[:q])
    @users = @q.result.order(:username).paginate(page: params[:page])
  end
end
