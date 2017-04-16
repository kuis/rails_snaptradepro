class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home
  skip_after_action :verify_authorized, only: :home

  def home
    return redirect_to new_user_session_path unless user_signed_in?

    if current_organization
      redirect_to organization_appraisals_path(current_organization)
    elsif current_user.default_organization
      redirect_to organization_appraisals_path(current_user.default_organization)
    end
  end
end
