class PreLaunchRegistrationsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create, :success]
  skip_after_action :verify_authorized

  def new
    @pre_launch_registration = PreLaunchRegistration.new
  end

  def create
    @pre_launch_registration = PreLaunchRegistration.new(params[:pre_launch_registration])

    if @pre_launch_registration.valid?
      PreLaunchRegistrationMailer.registration_email(@pre_launch_registration)
                                 .deliver
      redirect_to success_pre_launch_registrations_path
    else
      render :new
    end
  end

  def success
  end
end
