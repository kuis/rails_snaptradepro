class Role < ActiveRecord::Base
  has_many :memberships, dependent: :destroy

  scope :staff, -> { where(name: ['Rep', 'Agent']) }
  scope :reps, -> { where(name: 'Rep') }

  def self.rep_sales_manager_role
    Role.find_by({name: 'Rep', profile: 'Sales Mgr'})
  end

  def profile_name
    "#{name} - #{profile}"
  end
end
