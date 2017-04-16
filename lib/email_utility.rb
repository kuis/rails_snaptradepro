class EmailUtility
  def self.delivery_enabled?(email_template)
    EmailTemplate.find_by_name(email_template).try(:is_active)
  end

  def self.extract_subject(email_template)
    EmailTemplate.find_by_name(email_template).try(:subject)
  end

  def self.extract_body(email_template)
    EmailTemplate.find_by_name(email_template).try(:body)
  end

  def self.get_available_mailer_methods
    Dir['app/mailers/*.rb'].each { |f| require File.basename(f, '.rb') }
    available_mailers = ActionMailer::Base.descendants
    available_mailers.delete(Devise::Mailer)
    mailer_functions = []
    available_mailers.each do |mailer|
      mailer_functions << mailer.instance_methods(false)
    end
    mailer_functions.flatten.sort.collect{|mailer_function|[mailer_function.to_s.humanize,mailer_function]}
  end

end
