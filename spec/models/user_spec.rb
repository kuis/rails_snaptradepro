require "spec_helper"

describe User do
  describe "validations" do
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of :email }
    it { should validate_presence_of :first_name }
    it { should validate_presence_of :last_name }

    context 'active' do
      let(:user) { create(:user, active: false) }
      let!(:membership) { create(:membership, user: user, active: false) }
      
      it 'should have at least one active membership to be active' do
        expect(user.memberships.active.count).to eq(0)
        user.active = true
        expect(user).to be_invalid

        expect(user.errors_on(:active)).to include('There are no active memberships')
      end
    end
  end

  describe "associations" do
    it { should have_many(:organizations).through(:memberships) }
    it { should have_many(:memberships) }
    it { should have_many(:appraisals) }
    it { should have_many(:roles).through(:memberships) }
  end

  describe "#valid_token?" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    it "compares against all of user's tokens" do
      tokens = create_list(:auth_token, 5, user: user)
      sample_token = tokens[3].token

      expect(user.token_valid?(sample_token)).to eq true
    end

    it "returns false if user has no tokens" do
      expect(user.token_valid?("12312314")).to eq false
    end

    it "returns false if the token is older than 2 weeks" do
      tokens = create_list(:auth_token, 5, user: user)
      sample_token = tokens[3]

      expect(user.token_valid?(sample_token.token)).to eq true

      sample_token.update(updated_at: 15.days.ago)
      expect(user.token_valid?(sample_token.token)).to eq false
    end

    it "only queries this user's tokens" do
      tokens = create_list(:auth_token, 2, user: other_user)
      sample_token = tokens[0].token

      expect(other_user.token_valid?(sample_token)).to eq true
      expect(user.token_valid?(sample_token)).to eq false
    end

    it "refreshes the token expiration time" do
      sample_token = create(:auth_token, user: user, updated_at: 12.days.ago)
      expect(sample_token.updated_at).to be < 1.minute.ago
      expect(user.token_valid?(sample_token.token)).to eq true
      expect(sample_token.reload.updated_at).to be > 1.minute.ago
    end
  end

  describe '#visible_organizations' do
    let(:user) { create(:user) }
    let(:stp_admin) { create(:user, admin: true) }
    let(:organization1) { create(:organization) }
    let(:organization2) { create(:organization) }
    let!(:membership) { create(:membership, :invitation_accepted, user: user, organization: organization1) }
    
    it 'should return only active organizations if user is not a super admin' do
      expect(user.memberships.by_organization(organization1).count).to eq(1)
      expect(user.memberships.by_organization(organization2).count).to eq(0)
      expect(user.visible_organizations.count).to eq(1)
      expect(user.visible_organizations.first).to eq(organization1)
    end

    it 'should return only active memberships' do
      membership.update_attribute(:active, false)
      expect(user.memberships.by_organization(organization1).count).to eq(1)
      expect(user.memberships.active.count).to eq(0)
      expect(user.visible_organizations.count).to eq(0)
    end

    it 'should return only invitation_accepted memberships' do
      membership.update_attribute(:invitation_accepted_at, nil)
      expect(user.memberships.by_organization(organization1).count).to eq(1)
      expect(user.memberships.active.count).to eq(0)
      expect(user.visible_organizations.count).to eq(0)
    end

    it 'should return all organizations if user is stp admin' do
      expect(stp_admin.visible_organizations.count).to eq(Organization.all.count)
    end
  end
end
