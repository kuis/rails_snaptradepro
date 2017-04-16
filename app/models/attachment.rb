class Attachment < ActiveRecord::Base
  belongs_to :attachable, polymorphic: true
  belongs_to :uploader, class_name: 'User', foreign_key: :uploaded_by

  validates_presence_of :uploader,
                        :file_name,
                        :file_size,
                        :file_url,
                        :file_type
end
