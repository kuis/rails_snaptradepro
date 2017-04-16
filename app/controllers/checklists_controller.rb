class ChecklistsController < ApplicationController
  def create
    @check_list = Checklist.create(name: check_list_params[:name], appraisal_id: check_list_params[:appraisal_id])
    authorize @check_list
  end

  def check_list_params
    params
      .require(:checklist)
      .permit(:name, :appraisal_id)
  end

  def edit
    @check_list = Checklist.find(params[:id])
    #@appraisal = Appraisal.find(check_list_params[:appraisal_id])
    authorize @check_list
  end

  def update
    @check_list = Checklist.find(params[:id])
    @check_list.update_attributes(check_list_params)

    authorize @check_list
  end

  def destroy
    @check_list = Checklist.find(params[:id])
    @check_list.destroy

    authorize @check_list
  end

end
