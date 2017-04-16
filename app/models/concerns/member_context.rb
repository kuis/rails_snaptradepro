class MemberContext
  attr_accessor :member, :organization

  def initialize(member, organization)
    @member = member
    @organization = organization
  end
end
