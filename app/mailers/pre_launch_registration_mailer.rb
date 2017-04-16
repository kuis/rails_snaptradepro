class PreLaunchRegistrationMailer < ActionMailer::Base
  def registration_email(pre_launch_registration)
    send_email_with(ENV["PRE_LAUNCH_REGISTRATION_EMAIL"],pre_launch_registration.to_hash,"Registration Email",:from=> pre_launch_registration.email)
  end
end
