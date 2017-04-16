class Customer < ActiveRecord::Base
  belongs_to :organization
  has_many :appraisals

  validates :organization, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :account_name, presence: true
  validates :business_phone, presence: true

  scope :visible, -> { where(archived: false) }
  scope :archived, -> { where(archived: true) }

  def name
    "#{first_name} #{last_name}"
  end
end
