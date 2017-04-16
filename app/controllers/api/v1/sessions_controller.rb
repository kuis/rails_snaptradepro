class Api::V1::SessionsController < Api::V1::BaseController
  version 1

  skip_before_filter :authenticate_user_from_token
  skip_before_filter :require_authentication!
  skip_after_filter :verify_authorized

  def create
    user = User.find_for_authentication(email: user_params[:email])

    if user && user.valid_password?(user_params[:password])
      token = user.generate_authentication_token
      user.destroy_old_tokens!

      expose({
        user_id: user.id,
        token: token
      })
    else
      error! :unauthenticated
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
