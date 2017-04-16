class MemberMailer < ActionMailer::Base
  default from: "\"Snap Trade Pro\" <noreply@snaptradepro.com>"

  def send_invitation(membership, member)
    attrs = {}
    attrs.merge!(Hash[member.attributes.map { |k, v| ["member_#{k}", v] }])
    attrs.merge!(Hash[membership.invitor.attributes.map { |k, v| ["invitor_#{k}", v] }])
    attrs.merge!({"organization_name" => membership.organization.name,
                  "full_invitation_token" => [membership.invitation_token, member.raw_invitation_token].join(','),
                  "accept_text" => I18n.t("devise.mailer.invitation_instructions.accept"),
                  "ignore_text" => I18n.t("devise.mailer.invitation_instructions.ignore", :signin_link => "#{root_url}users/sign_in", :site_link => ENV["EMAIL_HOST"]).html_safe,
                  "root_url" => root_url
                 })

    send_email_with(member.email, attrs, "Send invitation")
  end

  def notify_invitation_pending_back_to_invitor(membership)
    invitor = membership.invitor
    member = membership.user
    attrs = {}
    attrs.merge!(Hash[member.attributes.map { |k, v| ["member_#{k}", v] }])
    attrs.merge!(Hash[invitor.attributes.map { |k, v| ["invitor_#{k}", v] }])
    attrs.merge!({"organization_name" => membership.organization.name,
                  "root_url" => root_url})
    send_email_with(invitor.email, attrs, "Notify invitation pending back to invitor")
  end

  def notify_invitation_revoked_to_invitor(membership)
    invitor = membership.invitor
    member = membership.user
    attrs = {}
    attrs.merge!(Hash[member.attributes.map { |k, v| ["member_#{k}", v] }])
    attrs.merge!(Hash[invitor.attributes.map { |k, v| ["invitor_#{k}", v] }])
    attrs.merge!({"organization_name" => membership.organization.name,
                  "root_url" => root_url})

    send_email_with(invitor.email, attrs, "Notify invitation revoked to invitor")
  end

  def notify_invitation_deactivated_to_invitee(membership)
    invitor = membership.invitor
    member = membership.user
    attrs = {}
    attrs.merge!(Hash[member.attributes.map { |k, v| ["member_#{k}", v] }])
    attrs.merge!(Hash[invitor.attributes.map { |k, v| ["invitor_#{k}", v] }])
    attrs.merge!({"organization_name" => membership.organization.name,
                  "root_url" => root_url})

    send_email_with(invitor.email, attrs, "Notify invitation deactivated to invitee")
  end

  def notify_news_of_being_org_admin(org)
    attrs = {}
    attrs.merge!(Hash[org.admin.attributes.map { |k, v| ["admin_#{k}", v] }])
    attrs.merge!(Hash[org.attributes.map { |k, v| ["organization_#{k}", v] }])
    send_email_with(org.admin.email, attrs, "Notify news of being org admin")
  end

  def notify_news_of_being_org_owner(org)
    attrs = {}
    attrs.merge!(Hash[org.owner.attributes.map { |k, v| ["owner_#{k}", v] }])
    attrs.merge!(Hash[org.attributes.map { |k, v| ["organization_#{k}", v] }])
    send_email_with(org.owner.email, attrs, "Notify news of being org owner")
  end
end
