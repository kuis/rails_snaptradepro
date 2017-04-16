require 'spec_helper'
require 'rake'

describe 'member:reset_invitation' do
  let!(:user) { create(:user) }
  let!(:invitor) { create(:user) }

  before do
    SnapTradePro::Application.load_tasks
  end

  it 'should reset all unaccepted invitations which are 24 hours old' do
    FactoryGirl.create(:membership, user: user, 
                                    invitor: invitor, 
                                    invitation_token: 'xxx', 
                                    invitation_sent_at: Time.now - 25.hours)

    expect(Membership.invitation_sent.count).to eq(1)
    expect(Rake::Task['member:reset_invitation'].invoke).not_to raise_exception
    expect(Membership.invitation_sent.count).to eq(0)
    email = open_email(invitor.email)
    expect(email.subject).to eq("STP Member Invite 24 Hours Old")
  end
end
