class Api::V1::AppraisalsController < Api::V1::BaseController
  version 1

  skip_after_action :verify_authorized, only: [:index]
  after_action :verify_policy_scoped, only: [:index]
  before_action :load_organization, except: [:index]

  def index
    appraisals = policy_scope(Appraisal).visible

    customers = Set.new
    appraisals_by_customer = {}

    appraisals.each do |appraisal|
      customer_account = appraisal.customer.account_name
      appraisals_by_customer[customer_account] ||= []

      appraisal = AppraisalSerializer.new(appraisal)
      appraisals_by_customer[customer_account] << appraisal
    end

    expose appraisals_by_customer
  end

  def show
    appraisal = @organization.appraisals.find(params[:id])
    authorize appraisal

    appraisal = AppraisalSerializer.new(appraisal)

    appraisal.full_organization = true
    appraisal.include_appraisal_template = true
    appraisal.include_categories = true if params[:complete_categories].to_s == "true"

    expose appraisal.as_json
  end

  def create
    appraisal = @organization.appraisals.build(appraisal_params)
    appraisal.user = current_user
    authorize appraisal

    # don't require fields to be filled in until later
    appraisal.skip_custom_field_validation = true

    if appraisal.valid?
      appraisal.number = @organization.next_appraisal_number(increment: true)
      appraisal.save
      track_event('create-appraisal', appraisal)
      expose appraisal
    else
      error!(:invalid_resource, appraisal.errors)
    end
  end

  def update
    appraisal = @organization.appraisals.find(params[:id])
    authorize appraisal

    # don't require fields to be filled, trust mobile
    appraisal.skip_custom_field_validation = true

    if appraisal.update(appraisal_params)
      expose appraisal
    else
      error!(:invalid_resource, appraisal.errors)
    end
  end

  private

  def appraisal_params
    whitelisted = params.require(:appraisal)
                        .permit(:status, :appraisal_template_id,
                                :customer_id, :unit, :name)
    whitelisted[:custom_fields] = params[:appraisal][:custom_fields]
    whitelisted
  end

  def load_organization
    @organization = Organization.find(params[:organization_id])
  end

  def track_event(event_name, appraisal)
    return if ENV['INTERCOM_APP_KEY'].nil?

    Intercom::Event.create(
      event_name: event_name,
      created_at: Time.now.to_i,
      email: current_user.email,
      metadata: {
        appraisal_id: appraisal.id,
        appraisal_name: appraisal.name,
        appraisal_template: appraisal.appraisal_template.label,
        organization: appraisal.organization.name,
        device: 'Mobile'
      }
    )
  end
end
