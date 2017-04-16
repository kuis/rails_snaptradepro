class ChecklistItemsController < ApplicationController
  #before_action :find_checklist

  def new
    @check_list_item = ChecklistItem
      .new(checklist_id: params[:checklist_id], creator_id: current_user.id)
    authorize @check_list_item
  end

  def create
    @check_list_item = ChecklistItem
      .create(description: check_list_item_params[:description], checklist_id: params[:checklist_id])
    authorize @check_list_item
  end

  def edit
    @check_list_item = ChecklistItem.find(params[:id])
    authorize @check_list_item
  end

  def update
    @check_list_item = ChecklistItem.find(params[:id])
    @check_list_item.update_attributes(check_list_item_params)

    authorize @check_list_item
  end

  def destroy
    @check_list_item = ChecklistItem.find(params[:id])
    @check_list_item.destroy

    authorize @check_list_item
  end

  def completed
    @checklist_item = ChecklistItem.find(params[:id])
    @checklist_item.update_attributes(completed: true, completed_at: DateTime.now)

    render json: { status: 200 }
    authorize @checklist_item
  end

  def uncompleted
    @checklist_item = ChecklistItem.find(params[:id])
    @checklist_item.update_attributes(completed: false, completed_at: nil)

    render json: { status: 200 }
    authorize @checklist_item
  end

  def check_list_item_params
    params
      .require(:checklist_item)
      .permit(:description, :checklist_id)
  end
end

