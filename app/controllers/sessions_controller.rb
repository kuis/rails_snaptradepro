class SessionsController < Devise::SessionsController
  def destroy
    session[:organization_id] = nil
    super
  end
end
