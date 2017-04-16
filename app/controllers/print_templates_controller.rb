class PrintTemplatesController < ApplicationController
  skip_after_action :verify_authorized
  before_action :find_resource, only: [:edit, :show, :update, :destroy]

  def index
    @print_templates = PrintTemplate.all
  end

  def new
    @print_template = PrintTemplate.new
  end

  def edit
  end

  def create
    @print_template = PrintTemplate.new(print_template_params)
    if @print_template.save
      add_print_template_blocks
      redirect_to print_templates_path, notice: "New print template is created."
    else
      render :new, alert: "Faild to create new print template."
    end
  end

  def update
    if @print_template.update_attributes(print_template_params)
      @print_template.print_template_blocks.destroy_all
      add_print_template_blocks
      redirect_to print_templates_path, notice: "Print template is updated."
    else
      render :edit, alert: "Failed to update print template."
    end
  end

  def destroy
  end

  private
  def print_template_params
    params.require(:print_template).permit(:name, :description, :appraisal_template_id, :layout_type)
  end

  def find_resource
    @print_template = PrintTemplate.find(params[:id])
  end

  def add_print_template_blocks
    # Add retail price field
    if params[:retail_price_field_id]
      @print_template.print_template_blocks.create({
        blockable_id: params[:retail_price_field_id],
        blockable_type: "numeric",
        page: 0
      })
    end

    if params[:sales_manager]
      @print_template.print_template_blocks.create({
        blockable_id: params[:sales_manager],
        blockable_type: "user",
        page: 0
      })
    end

    if params[:price_fields]
      params[:price_fields].each do |price_field|
        @print_template.print_template_blocks.create({
          blockable_id: price_field,
          blockable_type: "numeric",
          page: 0
        })
      end
    end

    (params[:blocks] || []).each_with_index do |block, i|
      @print_template.print_template_blocks.create(
        page: params[:in_page][i].to_i,
        section: params[:section][i],
        blockable_id: block.to_i,
        blockable_type: params[:block_type][i],
        properties: { hidden_fields: params[:hidden_fields][i] }
      )
    end
  end

end
