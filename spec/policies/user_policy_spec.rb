require 'spec_helper'

describe UserPolicy do
  subject { UserPolicy }
  let (:organization) { create(:organization) }
  let (:org_member) { create(:org_member) }
  let (:member_context) { MemberContext.new(org_member, organization) }
  let (:org_admin) { create(:org_admin, :logged_in, current_organization: organization) }
  let (:org_owner) { create(:org_owner, :logged_in, current_organization: organization) }
  let (:org_other_member) { create(:org_member, :logged_in, current_organization: organization) }
  let (:member_in_other_org) { create(:org_member, :logged_in) }

  permissions :show? do
    it "denies access if not a member of organization" do
      expect(subject).not_to permit(member_in_other_org, member_context)
    end

    it "allows access for an org admin" do
      expect(subject).to permit(org_admin, member_context)
    end

    it "allows access for an org owner" do
      expect(subject).to permit(org_admin, member_context)
    end

    it "allows access for an org member" do
      expect(subject).to permit(org_other_member, member_context)
    end
  end

  permissions :update? do
    it "prevents updates if not an org admin or org owner" do
      expect(subject).not_to permit(org_other_member, member_context)
    end
    it "allows an org admin to update" do
      expect(subject).to permit(org_admin, member_context)
    end
    it "allows an org admin to update" do
      expect(subject).to permit(org_owner, member_context)
    end

    it "allows updates self info" do
      expect(subject).to permit(org_member, member_context)
    end
  end
end
