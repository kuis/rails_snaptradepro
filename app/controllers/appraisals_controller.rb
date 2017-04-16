class AppraisalsController < ApplicationController
  before_action :find_appraisal, only: [:show, :edit, :update, :destroy,
                                        :archive, :clone, :sales_sheet, :appraisal_sheet,
                                        :remove_entry, :history, :comment, :valuations,
                                        :valuation, :valuation_history, :pin, :unpin, :convert_et,:find_et_templates]
  before_action :hide_left_nav, except: [:index]
  before_action :load_selected_appraisal_columns, :only => [:index, :archived]

  def hide_left_nav
    @show_left_nav = false
  end

  def index
    @appraisals = filtered_appraisals
    authorize @appraisals.first || Appraisal.new(organization_id: @organization.id)
  end

  def pin
    AppraisalUserPin.create(
      appraisal_id: params[:id],
      user_id: current_user.id,
      appraisal_category_id: params[:category_id]
    )
    render nothing: true
    authorize @appraisal
  end

  def unpin
    AppraisalUserPin.where(
      appraisal_id: params[:id],
      user_id: current_user.id,
      appraisal_category_id: params[:category_id]
    ).delete_all

    render nothing: true
    authorize @appraisal
  end

  def valuations
    load_separate_categories

    @categories = @appraisal
      .appraisal_template
      .visible_categories
      .where(label: ["requested_value", "approved_value", "expected_acquisition_date",
        "estimated_reconditioning", "approved_reconditioning", "approved_good_until_date",
        "proposed_retail", "approved_retail"])

    @valuation_fields = Valuation
      .find_by_appraisal_id(@appraisal.id)

    if @valuation_fields.blank?
      Valuation.create(appraisal_id: @appraisal.id)
      @valuation_fields = Valuation
        .find_by_appraisal_id(@appraisal.id)
    end

    @categories = []
    @appraisal_comments = @appraisal.comments.where("user_id IS NOT NULL")
    @appraisal_comment = @appraisal.comments.new

    @pinned_items = AppraisalUserPin
      .where(appraisal_id: @appraisal.id, user_id: current_user.id)
      .pluck(:appraisal_category_id)
    @pinned_categories = AppraisalCategory.where(id: @pinned_items)

    @check_lists = Checklist
      .where(appraisal_id: @appraisal.id)
      .includes(:checklist_items)
    @discussions = Discussion
      .where(appraisal_id: @appraisal.id)
    @discussion = Discussion.new
    @discussion.comments.build

    @valuation_urls = ValuationUrl
      .where(appraisal_id: @appraisal.id)
    @valuation_url = ValuationUrl.new

    authorize @appraisal
  end

  def valuation
    @valuation = Valuation.find_by_appraisal_id(@appraisal.id)
    @valuation.update_attributes(valuation_params)
    redirect_to valuations_organization_appraisal_path(@appraisal.organization, @appraisal)
    authorize @appraisal
  end

  def valuation_history
    @valuation = Valuation.find_by_appraisal_id(@appraisal.id)
    authorize @appraisal, :valuation?
  end

  def valuation_params
    params
      .require(:valuation)
      .permit(:requested_value, :approved_value, :expected_acquisition_date, :estimated_reconditioning, :approved_reconditioning, :approved_good_until_date, :proposed_retail, :approved_retail, :trade_conditions)
  end

  def show
    load_separate_categories

    @pinned_items = AppraisalUserPin
      .where(appraisal_id: @appraisal.id, user_id: current_user.id)
      .pluck(:appraisal_category_id)

    @appraisal_comments = @appraisal.comments.where("user_id IS NOT NULL")
    @appraisal_comment = @appraisal.comments.new

    authorize @appraisal
  end

  def new
    template = @organization.appraisal_templates.find(params[:appraisal_template_id])
    @appraisal = @organization.appraisals.build(appraisal_template: template)

    @appraisal.number = @organization.next_appraisal_number
    load_separate_categories
    authorize @appraisal
  end

  def create
    @appraisal = @organization.appraisals.build(appraisal_params)
    @appraisal.user = current_user
    authorize @appraisal

   if @appraisal.valid?
      @appraisal.number = @organization.next_appraisal_number(increment: true)
      @appraisal.save
      track_event('create-appraisal', @appraisal)
      redirect_to [@organization, @appraisal], notice: "Appraisal created."
    else
      load_separate_categories
      render :new
    end
  end

  def edit
    load_separate_categories
    authorize @appraisal
  end

  def update
    authorize @appraisal

    if @appraisal.update(appraisal_params)
      redirect_to [@organization, @appraisal], notice: "Appraisal updated."
    else
      load_separate_categories
      render :edit
    end
  end

  def convert_et
     authorize @appraisal
    target_appraisal_template = @organization.appraisal_templates.find(params[:template_id])
    if @appraisal.update_attribute(:appraisal_template_id,target_appraisal_template.id)
      redirect_to [@organization, @appraisal], notice: "Appraisal successfully converted"
    else
      redirect_to :back, notice: "Something went wrong!!"
    end
  end

  def find_et_templates
    authorize @appraisal
    @target_appraisal_templates = @organization.appraisal_templates.joins(:equipment_type).where("equipment_types.id = ?", params[:et_id])
    render layout: false
  end

  def sales_sheet
    authorize @appraisal
    @template = @appraisal.appraisal_template.print_templates.with_layout_type(:sales_sheet).first
    if @template.nil?
      redirect_to [@organization, @appraisal],
                  alert: "#{@appraisal.appraisal_template.label} has no print template" and return
    end
    @membership = Membership.by_organization(@organization.id)
                            .by_user(current_user.id).representatives.first
    is_manager = @organization.admin?(current_user) || @organization.owner?(current_user)

    if !is_manager && @membership.nil?
      redirect_to [@organization, @appraisal],
                  alert: "You are not representative of this organization" and return
    end

    load_printable_appraisal_categories
    respond_to do |format|
      format.html { render layout: 'preview' }
      format.pdf do
        render pdf: format(@appraisal.name),
               template: 'appraisals/sales_sheet',
               layout: 'layouts/pdf.html.haml',
               page_size: 'Letter',
               # show_as_html: true,
               header: {
                 html: {
                   template: 'shared/pdf/header',
                   locals: { organization: @organization }
                 },
               },
               footer: {
                 html: {
                   template: 'shared/pdf/footer',
                   locals: { organization: @organization }
                 },
               },
               margin: {
                 top: 31,
                 bottom: 50,
                 left: 0,
                 right: 0
               }
      end
    end
  end

  def appraisal_sheet
    authorize @appraisal
    @template = @appraisal.appraisal_template.print_templates.with_layout_type(:appraisal_sheet).first
    if @template.nil?
      redirect_to [@organization, @appraisal],
                  alert: "#{@appraisal.appraisal_template.label} has no print template" and return
    end

    @blocks = @template.print_template_blocks.tables
    @appraisal_categories = AppraisalCategory.where(id: @blocks.map(&:blockable_id))

    @membership = Membership.by_organization(@organization.id)
                            .by_user(current_user.id).representatives.first
    is_manager = @organization.admin?(current_user) || @organization.owner?(current_user)
    if !is_manager && @membership.nil?
      redirect_to [@organization, @appraisal],
                  alert: "You are not representative of this organization" and return
    end

    load_printable_appraisal_categories
    respond_to do |format|
      format.html { render layout: 'preview' }
      format.pdf do
        @sales_manager = User.find_by(id: params[:sales_manager])
        @rep = User.find_by(id: params[:rep])
        render pdf: format(@appraisal.name),
               template: 'appraisals/appraisal_sheet',
               layout: 'layouts/pdf.html.haml',
               page_size: 'Letter',
               margin: {
                 top: 0,
                 bottom: 0,
                 left: 0,
                 right: 0
               }
      end
    end
  end

  def archived
    @appraisals = @organization.appraisals.archived
    if (params[:equipment_type_id] && @organization.is_equipment_type_enabled? && @organization.equipment_type_ids.include?(params[:equipment_type_id].to_i))
      @appraisals = @appraisals.joins(:appraisal_template => :equipment_type).where("equipment_types.id = ?",params[:equipment_type_id] )
    end
    authorize @appraisals.first || Appraisal.new(organization_id: @organization.id)
  end

  def archive
    authorize @appraisal
    @appraisal.skip_custom_field_validation = true
    @appraisal.update!(archived: archive?)

    if archive?
      redirect_to organization_appraisals_path(@organization),
                  notice: "Appraisal archived."
    else
      redirect_to [@organization, @appraisal],
                  notice: "Appraisal un-archived."
    end
  end

  def bulk_archive
    if params[:appraisal_ids].nil?
      authorize Appraisal.new(organization_id: @organization.id)
      action = archive? ? "archive" : "un-archive"
      redirect_to :back, notice: "Please select appraisal(s) to #{action}"
    else
      params[:appraisal_ids].each do |id|
        appraisal = Appraisal.find(id)
        authorize appraisal
        appraisal.update!(archived: archive?)
      end

      if archive?
        redirect_to organization_appraisals_path(@organization),
                    notice: "#{params[:appraisal_ids].size} Appraisal(s) archived."
      else
        redirect_to archived_organization_appraisals_path(@organization),
                    notice: "#{params[:appraisal_ids].size} Appraisal(s) un-archived."
      end
    end
  end

  def clone
    authorize @appraisal
    # if number of clones is empty, return
    if params[:number_of_clones].empty?
      redirect_to [@organization, @appraisal],
                  alert: "Please enter the number of clones" and return

    end

    number_of_clones = params[:number_of_clones].to_i
    if number_of_clones <= 0 or number_of_clones > 99
      redirect_to [@organization, @appraisal],
                  alert: "Number of clones must be in range of 1 ~ 99" and return
    end

    number_of_clones.times do
      Appraisal.clone(@appraisal)
    end
    redirect_to organization_appraisals_path(@organization),
                notice: "#{number_of_clones} appraisal(s) cloned."
  end

  def remove_entry
    authorize @appraisal
    entry = AppraisalEntry.find(params[:entry_id])
    entry.destroy
    redirect_to :back, notice: "Appraisal Entry has been removed."
  end

  def history
    @field_entry = @appraisal.field_entry(params[:field_id].to_i)
    @history = @field_entry.versions
    authorize @appraisal
  end

  def comment
    @comment = @appraisal.comments.create(comment_params)
    authorize @comment

    @comment.user = current_user
    @comment.save

    respond_to do |format|
      format.js
    end
  end

  def reveal_comments
    @comments = Comment.where(commentable_id: params[:id])
    @comments.update_all(hidden: false, revealed_at: DateTime.now, revealed_by: current_user.id)
    authorize @comments
  end

  def hide_comments
    @comments = Comment.where(commentable_id: params[:id])
    @comments.update_all(hidden: true, revealed_at: nil, revealed_by: nil)
    authorize @comments
  end

  private

  def find_appraisal
    @appraisal = Appraisal.find(params[:id])
  end

  def archive?
    !params[:unarchive]
  end

  def load_separate_categories
    @categories_without_id = categories_without_id
    @id_category = id_category
  end

  def load_printable_appraisal_categories
    @id_category      = id_category
    @hero_shot        = @appraisal.appraisal_template.visible_categories.find_by(label: "Hero Shot")
    @photos           = @appraisal.appraisal_template.visible_categories.find_by(label: "Photos - Original")
    @power_train      = @appraisal.appraisal_template.visible_categories.find_by(name: "powertrain")
    @body             = @appraisal.appraisal_template.visible_categories.find_by(name: "body_truck_tractor")
    @valuation        = @appraisal.appraisal_template.visible_categories.find_by(name: "valuation")
    @truck_chassis    = @appraisal.appraisal_template.visible_categories.find_by(name: "truck_chassis")
    @wheels_tires     = @appraisal.appraisal_template.visible_categories.find_by(name: "wheels_tires")
    @warranty_inspection = @appraisal.appraisal_template.visible_categories.find_by(name: "warranty_inspection")
    @attach_tractor   = @appraisal.appraisal_template.visible_categories.find_by(name: "attach_tractor")
    @appraisal_comment = @appraisal.appraisal_template.visible_categories.find_by(name: "appraisal_comment")
  end

  def categories_without_id
    @appraisal
      .appraisal_template
      .visible_categories
      .weighted
      .without_id
      .where.not(name: ["appraisal_comment", "valuation"])
  end

  def id_category
    @appraisal.appraisal_template.visible_categories.find_by(label: "Identification")
  end

  def appraisal_params
    whitelisted = params.require(:appraisal)
                        .permit(:number, :status, :appraisal_template_id,
                                :customer_id, :unit, :name, :archived)
    whitelisted[:custom_fields] = params[:appraisal][:custom_fields]

    whitelisted
  end

  def comment_params
    params.require(:comment)
      .permit(:state_of_sale, :title, :comment, :price)
  end

  def filtered_appraisals
    appraisals = @organization.appraisals.visible
    appraisals = appraisals.where(customer_id: params[:customer_id]) if params[:customer_id]
    appraisals = appraisals.where(user_id: params[:member_id]) if params[:member_id]
    if params[:equipment_type_id].present? && @organization.is_equipment_type_enabled? && @organization.equipment_type_ids.include?(params[:equipment_type_id].to_i)
      appraisals = appraisals.joins(:appraisal_template => :equipment_type).where("equipment_types.id = ?",params[:equipment_type_id] )
    end
    # appraisals = appraisals.where(status: params[:status]) if params[:status]
    appraisals
  end

  def filtered_customer
    Customer.find(params[:customer_id]) if params[:customer_id]
  end

  def filtered_member
    User.find(params[:member_id]) if params[:member_id]
  end

  def filtered_equipment_type
    EquipmentType.find(params[:equipment_type_id]) if (params[:equipment_type_id] && @organization.is_equipment_type_enabled? && @organization.equipment_type_ids.include?(params[:equipment_type_id].to_i))
  end

  helper_method :filtered_customer
  helper_method :filtered_member
  helper_method :filtered_equipment_type

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
        device: 'Web Browser'
      }
    )
  end

  def load_selected_appraisal_columns
    @columns = (1..AppraisalColumn::COLUMNS.count).collect{|i| @organization.appraisal_columns.find_by_column_name("column#{i}") }
    @columns = @columns.unshift(nil)
    prepare_selectable_columns_data
  end
end
