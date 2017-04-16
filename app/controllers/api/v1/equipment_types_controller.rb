class Api::V1::EquipmentTypesController < Api::V1::BaseController
  version 1
  #respond_to :json

  skip_after_action :verify_authorized
  after_action :verify_policy_scoped
  before_action :load_organization

  def index
    expose find_with_association(policy_scope(EquipmentType))
  end

  def show
    expose find_with_association(policy_scope(EquipmentType)).find(params[:id])
  end

  def appraisals
    expose find_exposeable_appraisals_with_et_id_and_type(params[:id])
  end

  def archived_appraisals
    expose find_exposeable_appraisals_with_et_id_and_type(params[:id],"archived")
  end


  private

  def load_organization
    @organization = Organization.find(params[:organization_id])
  end

  def find_exposeable_appraisals_with_et_id_and_type(et_id,type="visible")
    equipment_type = policy_scope(EquipmentType).find(et_id)
    appraisals = policy_scope(Appraisal).where("organization_id=?",@organization.id).send(type.to_sym)
    appraisals.collect{|app| app if app.appraisal_template.equipment_type.id == equipment_type.id}.compact
  end

  def find_with_association(equipment_type)
    equipment_type.joins(:organization_equipment_types)
      .select("equipment_types.id,equipment_types.name,equipment_types.label,organization_equipment_types.user_creatable as user_creatable")
      .where("organization_equipment_types.organization_id = ?", @organization.id)
  end

end
