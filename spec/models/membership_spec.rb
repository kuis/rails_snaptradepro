require "spec_helper"

describe Membership do
  describe "associations" do
    it { should belong_to :user }
    it { should belong_to :organization }
    it { should belong_to :role }
  end

  describe "validations" do
  end

  describe "scopes" do
    let!(:invitation_sent) { create(:membership, :invitation_sent) }
    let!(:invitation_pending) { create(:membership, :invitation_pending) }
    let!(:invitation_revoked) { create(:membership, :invitation_revoked) }
    let!(:invitation_accepted) { create(:membership, :invitation_accepted) }

    context ".invitation_accepted" do
      it "should list only invitation_accepted memberships" do
        expect(Membership.invitation_not_accepted.count).to eq(3)
        expect(Membership.invitation_accepted.count).to eq(1)
      end
    end

    context ".invitation_sent" do
      it "should list only invitation_sent memberships" do
        expect(Membership.invitation_sent.count).to eq(1)
      end
    end

    context ".invitation_revoked" do
      it "should list only invitation_revoked memberships" do
        expect(Membership.invitation_revoked.count).to eq(1)
      end
    end

    context ".invitation_pending" do
      it "should list only invitation_revoked memberships" do
        expect(Membership.invitation_pending.count).to eq(1)
      end
    end
  end
end
