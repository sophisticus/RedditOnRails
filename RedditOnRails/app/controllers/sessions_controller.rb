class SessionsController < ApplicationController
  before_action :require_logged_out!, only: [:new, :create]
  before_action :require_logged_in!, only: [:destroy]

  def new
    render :new
  end

  def create
    @user = User.find_by_credentials(
      params[:user][:username],
      params[:user][:password]
    )

    if @user
      log_in(@user)
      redirect_to subs_url
    else
      flash.now[:errors] = ["Invalid username/password combination."]
      render :new
    end
  end

  def destroy
    current_user.session_token = nil
    log_out
    redirect_to new_session_url
  end
end
