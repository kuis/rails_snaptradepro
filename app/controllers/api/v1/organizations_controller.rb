class Api::V1::OrganizationsController < Api::V1::BaseController
  version 1

  skip_after_action :verify_authorized, only: [:index]
  after_action :verify_policy_scoped, only: [:index]

  def index
    expose policy_scope(Organization)
  end
end
