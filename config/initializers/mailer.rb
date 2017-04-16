require 'email_utility'
ActionMailer::Base.class_eval do

  def send_email_with(recipients,attrs,template,options={})
    if EmailUtility.delivery_enabled?(template)
      body = Liquid::Template.parse(EmailUtility.extract_body(template))
      subject = Liquid::Template.parse(EmailUtility.extract_subject(template))
      mail_options = {to: recipients, subject: subject.render(attrs)}
      mail_options.merge!(options)
      mail mail_options do |format|
        format.html { render html: body.render(attrs).html_safe }
      end
    end
  end

end

