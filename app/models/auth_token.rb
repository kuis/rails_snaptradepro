class AuthToken < ActiveRecord::Base
  TOKEN_VALID_TIME = 2.weeks

  belongs_to :user

  validates :token, presence: true, uniqueness: true
  validates :user, presence: true

  scope :not_expired, -> { where("updated_at > ?", TOKEN_VALID_TIME.ago) }
  scope :expired, -> { where("updated_at < ?", TOKEN_VALID_TIME.ago) }

  def self.generate!(user)
    auth_token = new(user: user)

    begin
      auth_token.token = SecureRandom.hex
    end until auth_token.save

    auth_token
  end
end
