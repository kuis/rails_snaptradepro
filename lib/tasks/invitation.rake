namespace :member do
  desc 'invitation_sent -> pending if invitee did not accept within 24 hours'
  task :reset_invitation => :environment do
    unaccepted_memberships = Membership.invitation_sent
                                       .where('invitation_sent_at < ?', Time.now - 24.hours)
    unaccepted_memberships.each do |membership|
      membership.invitation_sent_at = nil
      membership.save
      MemberMailer.notify_invitation_pending_back_to_invitor(membership).deliver
    end
  end

  desc 'deactivate invitations which have been 30 days old'
  task :deactivate_invitation => :environment do
    issued_memberships = Membership.invitation_pending
                                   .where('invitation_created_at < ?', Time.now - 30.days)
    issued_memberships.each do |membership|
      membership.invitation_token = nil
      membership.invitation_sent_at = nil
      membership.save
      MemberMailer.notify_invitation_revoked_to_invitor(membership).deliver
      MemberMailer.notify_invitation_deactivated_to_invitee(membership).deliver
    end
  end
end
