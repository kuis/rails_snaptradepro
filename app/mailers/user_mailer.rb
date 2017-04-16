class UserMailer < ActionMailer::Base
  default from: "\"Snap Trade Pro\" <noreply@snaptradepro.com>"

  def notify_reactivation(user)
    attrs = {}
    attrs.merge!(Hash[user.attributes.map { |k, v| ["user_#{k}", v] }])
    send_email_with(user.email,attrs,"Notify reactivation")
  end

end
