class RequestPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      scope.all
    end
  end

  attr_reader :user, :request

  def initialize(user, request)
    @user = user
    @request = request
  end

  def new?
    user.request.nil?
  end

  def create?
    new?
  end

  def edit?
    request.requester == user && !request.pledges.exists?
  end

  def show?
    true
  end

  def update?
    edit?
  end

  def manage?
    request.requester == user
  end
end