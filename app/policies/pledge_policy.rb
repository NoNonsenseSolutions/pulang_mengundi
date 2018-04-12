class PledgePolicy
  attr_reader :user, :pledge

  def initialize(user, pledge)
    @user = user
    @pledge = pledge
  end

  def new?
    true
  end

  def create?
    new?
  end

  def show?
    pledge.donor == user
  end

  def donor_status_update?
    pledge.donor == user
  end

  def requester_status_update?
    pledge.request.requester == user
  end
end