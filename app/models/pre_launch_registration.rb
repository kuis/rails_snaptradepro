class PreLaunchRegistration
  include ActiveModel::Model

  attr_accessor :first_name, :last_name, :email

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true

  def to_hash
    instance_variables.map do |var|
      [var[1..-1].to_s, instance_variable_get(var)]
    end.to_h
  end

  def persisted?
    false
  end
end
