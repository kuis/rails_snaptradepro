require 'spec_helper'
require 'rake'

describe 'member:deactivate_invitation' do
  let!(:user) { create(:user) }
  let!(:invitor) { create(:user) }

  before do
    SnapTradePro::Application.load_tasks
  end

  it 'should revoke invitations which are 30 days old' do
    FactoryGirl.create(:membership, user: user, 
                                    invitor: invitor, 
                                    invitation_token: 'xxx', 
                                    invitation_created_at: Time.now - 31.days)

    expect(Membership.invitation_pending.count).to eq(1)
    expect(Rake::Task['member:deactivate_invitation'].invoke).not_to raise_exception
    expect(Membership.invitation_pending.count).to eq(0)
    
    email = open_email(invitor.email)
    expect(email.subject).to eq("STP Member Invite 30 Days Old")

    email = open_email(user.email)
    expect(email.subject).to eq("Your STP Member Invitation has lapsed")
  end
end
