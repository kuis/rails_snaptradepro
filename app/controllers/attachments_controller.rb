class AttachmentsController < ApplicationController
  def create
    attachment = Attachment.new(attachment_params)
    attachment.uploader = current_user
    authorize attachment

    if attachment.save
      respond_to do |format|
        format.json { render json: attachment }
      end
    else
      respond_to do |format|
        format.json { render json: attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    attachment = Attachment.find(params[:id])
    authorize attachment
    attachment.destroy
    render json: { id: attachment.id }
  end

  private
  def attachment_params
    params.require(:attachment)
          .permit(:file_url, :file_type, :file_name, :file_size, :attachable_id, :attachable_type)
  end
end
