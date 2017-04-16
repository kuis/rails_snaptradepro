class ReportPolicy < BasePolicy
  def in_report?
    true
  end

  alias_method :index?, :in_report?
  alias_method :inventory_commitments?, :in_report?
end