Paperclip::Attachment.default_options.merge!(
  storage: :s3,
  s3_protocol: 'https',
  url: ':s3_domain_url',
  s3_credentials: {
    access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
    secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
    bucket:            ENV['AWS_S3_BUCKET']
  },
  path: 'uploads/:class/:id/:attachment/:filename',
  default_url: "",
  s3_permissions: :public_read
)
