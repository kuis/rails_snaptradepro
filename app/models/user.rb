class User < ActiveRecord::Base
  devise :invitable, :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :first_name, presence: true
  validates :last_name, presence: true
  
  validate :check_memberships, if: 'active?', on: :update

  has_many :appraisals
  has_many :memberships, dependent: :destroy
  has_many :organizations, through: :memberships
  has_many :roles, through: :memberships
  has_many :attachments, foreign_key: "uploaded_by", class_name: "Attachment"
  has_many :auth_tokens, dependent: :destroy
  has_many :invitations, foreign_key: 'invited_by', class_name: 'Membership'

  accepts_nested_attributes_for :memberships, allow_destroy: true
  attr_accessor :current_organization

  has_attached_file :avatar
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  after_validation :check_archived
  before_save :check_activation

  scope :sales_managers, -> { joins(:roles).where(roles: { profile: 'Sales Mgr' }) }
  
  scope :archived, -> { where(archived: true) }
  scope :unarchived, -> { where.not(archived: true) }

  default_scope -> { order('created_at ASC') }

  def default_organization
    visible_organizations.first
  end

  def visible_organizations
    active_organizations = organizations.includes(:memberships)
                                        .where('memberships.invitation_accepted_at IS NOT NULL and memberships.active = true')
    admin? ? Organization.all : active_organizations
  end

  def name
    "#{first_name} #{last_name}"
  end

  def full_address
    addr = [street_address, city, state].compact.reject(&:empty?).join(", ")
    [addr, postal_code].join(" ")
  end

  def job_title_at_org(org)
    membership = self.memberships.where(organization: org.id).first
    membership.try(:job_title)
  end

  def generate_authentication_token
    auth_token = AuthToken.generate!(self)
    auth_token.token
  end

  def token_valid?(token)
    auth_token = auth_tokens.not_expired.detect do |auth_token|
      Devise.secure_compare(auth_token.token, token)
    end

    if auth_token.present?
      auth_token.touch
      true
    else
      false
    end
  end

  def destroy_old_tokens!
    auth_tokens.expired.destroy_all
  end

  def active_for_authentication?
    active? || admin?
  end

  private

  def check_activation
    if active_changed?
      if active?
        UserMailer.notify_reactivation(self).deliver
      else
        # Deactive all memberships
        memberships.update_all(active: false)
      end
    end
  end

  def check_memberships
    return if memberships.pluck(:active).any?
    if active_changed?
      errors.add(:active, 'There are no active memberships')
    end
  end

  def check_archived
    if archived_changed? && archived?
      self.active = false
    end
  end
end
