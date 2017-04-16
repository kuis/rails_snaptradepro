require 'spec_helper'

describe PrintTemplatePolicy do
  subject { PrintTemplatePolicy }

  let (:current_user) { FactoryGirl.build_stubbed :user }
  let (:other_user) { FactoryGirl.build_stubbed :user }
  let (:admin) { FactoryGirl.create(:user, admin: true) }

  permissions :index? do
    it "denies access if not an admin" do
      expect(PrintTemplatePolicy).not_to permit(current_user)
    end
    it "allows access for an admin" do
      expect(PrintTemplatePolicy).to permit(admin)
    end
  end

  permissions :create? do
    it "prevents creates if not an admin" do
      expect(subject).not_to permit(current_user)
    end
    it "allows an admin to make creates" do
      expect(subject).to permit(admin)
    end
  end

  permissions :update? do
    it "prevents updates if not an admin" do
      expect(subject).not_to permit(current_user)
    end
    it "allows an admin to make updates" do
      expect(subject).to permit(admin)
    end
  end

  permissions :destroy? do
    it "prevents deletes if not an admin" do
      expect(subject).not_to permit(current_user)
    end
    it "allows an admin to delete any template" do
      expect(subject).to permit(admin)
    end
  end
end
