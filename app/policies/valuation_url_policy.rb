class ValuationUrlPolicy < BasePolicy
  def in_valuation?
    true
  end

  alias_method :create?, :in_valuation?
  alias_method :show?, :in_valuation?
end
