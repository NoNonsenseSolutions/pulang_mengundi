class PledgePolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      scope.where(donor: user)
    end
  end


  attr_reader :user, :pledge

  def initialize(user, pledge)
    @user = user
    @pledge = pledge
  end

  def new?
    pledge.request.requester != user
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