# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

if Rails.env.development?
  user = CreateAdminService.new.call
  puts 'CREATED ADMIN USER: ' << user.email

  puts 'Create organization'
  org = FactoryGirl.create(:organization)

  puts 'Create 20 appraisals'

  2.times do
    FactoryGirl.create(:appraisal, user_id: 1, organization: org)
  end
end

Role.find_or_create_by(name: "Org Owner", profile: "Owner")
Role.find_or_create_by(name: "Org Admin", profile: "Admin")
Role.find_or_create_by(name: "Rep",       profile: "Member")
Role.find_or_create_by(name: "Rep",       profile: "Sales Mgr")
Role.find_or_create_by(name: "Rep",       profile: "Sales Coordinator")
Role.find_or_create_by(name: "Rep",       profile: "Sales")

Role.find_or_create_by(name: "Agent",     profile: "Freelancer")
Role.find_or_create_by(name: "Agent",     profile: "Asset Controller")
Role.find_or_create_by(name: "Agent",     profile: "Potential Buyers")
Role.find_or_create_by(name: "Agent",     profile: "Recovery")
Role.find_or_create_by(name: "Agent",     profile: "Transport")
Role.find_or_create_by(name: "Agent",     profile: "Marketing")


EmailTemplate.find_or_create_by(name: "Notify reactivation") do |email_template|
  email_template.subject = "Snap Trade Pro - Reactivation"
  email_template.body = "<p>Welcome {{ user_first_name }},</p>\n<p>Your Snap Trade Pro account has been reactivated. Once you create a new password you may start using the application to gather, manage & create online inspections and appraisals.</p>\n<p>This invitation can be accepted through the link below where you will create your password.</p>\nReactivate Password\n<p>\n  Access the Snap Trade Pro web application by logging into \n  <a href='https://app.snaptradepro.com/users/sign_in'> https://app.snaptradepro.com/users/sign_in</a>\n  &nbsp;or by going to snaptradepro.com and clicking on 'Client Login' at the top of the page.\n</p>\n<p>\n  After you have set up your account password you may need to install the Snap Trade Pro Apple iOS app on an iPhone or iPod. To download go to\n  <a href='https://itunes.apple.com/us/app/snap-trade-pro/id931532400'> https://itunes.apple.com/us/app/snap-trade-pro/id931532400</a>\n  &nbsp;in the App Store.\n</p>\n<p>\n  Canadian downloads available at \n  <a href='https://itunes.apple.com/ca/app/snap-trade-pro/id931532400'> https://itunes.apple.com/ca/app/snap-trade-pro/id931532400</a>\n  &nbsp;in the App Store\n</p>\n<p>Feel free to contact either of us at the email addresses listed below regarding anything Snap Trade Pro.</p>\n<br>\n<p>Vince Green vince@inbounddealer.com</p>\n<p>Don James don@inbounddealer.com</p>\n<p>** This reactivation is exclusive to your email address. Please do not share this with anyone else.</p>\n<p>** If you don't want to accept reactivation, please ignore this email.</p>\nYour account won't be reactivated until you access the link above and set your password.\n"
  email_template.is_active = true
end

EmailTemplate.find_or_create_by(name: "Send invitation") do |email_template|
  email_template.subject = "Snap Trade Pro - Invitation"
  email_template.body = "<p>Welcome {{ member_first_name }},</p><p>{{ invitor_first_name }} {{ invitor_last_name }} has invited you to Snap Trade Pro where you can start using the application to gather, manage & create  online appraisals as well as manage inventory.</p><p>This invitation can be accepted through the link below where you will create your password. If you are already a User  of Snap Trade Pro you will be redirected to {{ organization_name }}'s Organization after you accept this invitation.</p><p><a href='{{ root_url }}members/accept_invitation?invitation_token={{ full_invitation_token }}'>{{ accept_text }}</a></p><p>{{ ignore_text }}</p>"
  email_template.is_active = true
end

EmailTemplate.find_or_create_by(name: "Notify news of being org admin") do |email_template|
  email_template.subject = "Your are an organization admin for {{ organization_name }}"
  email_template.body = "<p>Hi {{ admin_first_name }}</p><p>You are an organization admin of {{ organization_name }}</p>"
  email_template.is_active = true
end

EmailTemplate.find_or_create_by(name: "Notify news of being org owner")do |email_template|
  email_template.subject = "Your are an organization owner for {{ organization_name }}"
  email_template.body = "<p>Hi {{ owner_first_name }}</p><p>You are an organization owner of {{ organization_name }}</p>"
  email_template.is_active = true
end

EmailTemplate.find_or_create_by(name: "Notify invitation pending back to invitor") do |email_template|
  email_template.subject = "STP Member Invite 24 Hours Old"
  email_template.body = "<p>Hello {{ invitor_first_name }} {{ invitor_last_name }},</p><p>You have invited {{ member_first_name }} {{ member_last_name }} to {{ organization_name }} within Snap Trade Pro about 24 hours ago. Currently the invitation has not been accepted.</p><p>The invitation status will be changed to “Invitation Pending” in your list of Organization Members on your Member page.</p><p>When the invitation is accepted you will be notified by email and the invitation status will change to “Invitation Accepted”</p><p>This invitation will remain available for 30 days until it is accepted at which time the invitation will be revoked and the invitation status changed to “Invitation Revoked”.</p><p>You can resend any invitation, which has been revoked by clicking on the “Resend Invitation” button for your new Member.</p><p>Feel free to contact me at the email addresses listed below regarding anything Snap Trade Pro.</p><p>  Vince Green   <a href='mail_to(&#39;vince@inbounddealer.com&#39;)'>vince@inbounddealer.com</a></p><p>  Access the Snap Trade Pro web application by logging into   <a href='{{ root_url }}users/sign_in'>{{ root_url }}users/sign_in</a>  or by going to snaptradepro.com and clicking on 'Client Login' at the top of the page.</p><p>** All invitations are exclusive to an email address. They will not work if shared with anyone else.</p><p>  ** If your new Members don't want to accept the invitation, they may ignore the email.  <br>  Their account won't be created until they access the link above and set their password.</p>"
  email_template.is_active = true
end


EmailTemplate.find_or_create_by(name: "Notify invitation revoked to invitor")  do |email_template|
  email_template.subject = "STP Member Invite 30 Days Old"
  email_template.body = "<p>Hello {{ invitor_first_name }},</p><p>You have invited {{ member_first_name }} {{ member_last_name }} to {{ organization_name }} within Snap Trade Pro about 30 days ago. Currently the invitation has not been accepted.</p><p>The invitation status will be changed to “Invitation Revoked” in your list of Organization Members on your Member list page.</p><p>The invitation will no longer be able to be accepted by {{ member_first_name }}.</p><p>An email advising Sales that the invite has lapsed has been sent to {{ member_email }}.</p><p>If you would like to resend the invitation, click on the “Resend Invitation” button for your new Member in the Member list page now or anytime in the future.</p><p>Feel free to contact me at the email addresses listed below regarding anything Snap Trade Pro.</p><p>  Vince Green   <a href='mail_to(&#39;vince@inbounddealer.com&#39;)'>vince@inbounddealer.com</a></p><p>  Access the Snap Trade Pro web application by logging into   <a href='{{ root_url }}users/sign_in'>{{ root_url }}users/sign_in</a>  or by going to snaptradepro.com and clicking on 'Client Login' at the top of the page.</p><p>** All invitations are exclusive to an email address. They will not work if shared with anyone else.</p><p>  ** If your new Members don't want to accept the invitation, they may ignore the email.  <br>  Their account won't be created until they access the link above and set their password.</p>"
  email_template.is_active = true
end

EmailTemplate.find_or_create_by(name: "Notify invitation deactivated to invitee") do |email_template|
  email_template.subject = "Your STP Member Invitation has lapsed"
  email_template.body = "<p>Hello {{ member_first_name }},</p><p>You have been invited by {{ invitor_first_name }} {{ invitor_last_name}} of {{ organization_name }} into Snap Trade Pro about 30 days ago. Currently the invitation has not been accepted.</p><p>This invitation is now deactivated and will no longer work.</p><p>Please contact {{ invitor_first_name }} {{ invitor_last_name }} and request that they resend the invitation. When you receive the new invitation you will have only 30 days to Accept the new invitation.</p><p>Feel free to contact us at the email addresses listed below regarding anything Snap Trade Pro.</p><p>  Snap Trade Pro Support   <a href='mail_to(&#39;support@inbounddealer.com&#39;)'>support@inbounddealer.com</a></p><p>  Access the Snap Trade Pro web application by logging into   <a href='{{ root_url }}users/sign_in'>{{ root_url }}users/sign_in</a>  &nbsp;or by going to snaptradepro.com and clicking on 'Client Login' at the top of the page.</p><p>** All invitations are exclusive to an email address. They will not work if shared with anyone else.</p>"
  email_template.is_active = true
end

EmailTemplate.find_or_create_by(name: "Registration Email")  do |email_template|
  email_template.subject = "Snap Trade Pro - Pre Launch Registration"
  email_template.body = "<!DOCTYPE html><html>  <head>    <meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>  </head>  <body>    <h1>Pre Launch Registration</h1>    <p>      From: {{ first_name }} {{ last_name }}      <br>      Email: {{ email }}    </p>  </body></html>"
  email_template.is_active = true
end



trade_appraisal = EquipmentType.find_or_create_by(name: "TA") do |et|
  et.label = "Trade Appraisal"
end

EquipmentType.find_or_create_by(name: "UI") do |et|
  et.label = "Used Inventory"
end

EquipmentType.find_or_create_by(name: "NI") do |et|
  et.label = "New Inventory"
end

AppraisalTemplate.all.each do |at|
  unless at.equipment_type.present?
    at.update_attribute(:equipment_type_id,trade_appraisal.id)
  end
end



