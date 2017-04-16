class Membership < ActiveRecord::Base
  belongs_to :organization
  belongs_to :user
  belongs_to :role
  belongs_to :invitor, foreign_key: 'invited_by', class_name: 'User'

  attr_accessor :name, :user_email

  has_attached_file :avatar,
                    default_url: lambda { |image| ActionController::Base.helpers.asset_path('anonymous_avatar.png') }
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  validate :check_ownership, unless: 'active?', on: :update

  scope :by_organization, -> organization_id { where(organization_id: organization_id) }
  scope :by_user,         -> user_id { where(user_id: user_id) }
  scope :representatives, -> { joins(:role).where(roles: {name: ['Rep']}) }

  # Invitation scopes
  scope :invitation_not_accepted, -> { where.not(invitation_created_at: nil).where(invitation_accepted_at: nil) }
  scope :invitation_accepted, -> { where.not(invitation_accepted_at: nil) }
  scope :invitation_pending, -> { where.not(invitation_token: nil).where(invitation_sent_at: nil) }
  scope :invitation_sent, -> { invitation_not_accepted.where.not(invitation_sent_at: nil) }
  scope :invitation_revoked, -> { invitation_not_accepted.where(invitation_token: nil) }

  scope :active, -> { invitation_accepted.where(active: true) }

  after_save :check_activation

  def self.get_role(organization, user)
    membership = Membership.find_by({organization: organization, user: user})
    membership.role if membership.present?
  end

  def is_member?
    role.name == 'Rep'
  end

  def invite!(member, invited_by)
    self.invitation_token = loop do
      random_token = Devise.friendly_token.first(12)
      break random_token unless Membership.exists?(invitation_token: random_token)
    end
    self.invitation_sent_at = Time.now
    self.invitation_created_at = Time.now
    self.invitor = invited_by
    self.save
    MemberMailer.send_invitation(self, member).deliver
  end

  def accept_invitation!
    self.invitation_accepted_at = Time.now
    self.invitation_token = nil

    # Activate user
    user.update_attributes({ active: true, archived: false })
    self.active = true
    self.save
  end

  private

  def check_activation
    if active_changed? && !user.memberships.pluck(:active).all?
      user.active = false
      user.save
    end
  end

  def check_ownership
    if active_changed? && !active?
      if organization.admin?(user) || organization.owner?(user)
        errors.add(:active, "Org Owner and Org Admin can't be inactive")
      end
    end
  end
end
