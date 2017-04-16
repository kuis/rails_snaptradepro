class AttachmentSerializer < ActiveModel::Serializer
  attributes :id, :file_type, :file_size, :file_url, :file_name, :uploader, :created_at

  def uploader
    @object.uploader.name
  end

  def created_at
    @object.created_at.strftime("%F %H:%M")
  end
end
