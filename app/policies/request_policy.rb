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
    return true if request.requester == user
    return true if user.present? && request.pledges.pluck(:donor_id).include?(user.id)
    return false if @request.disabled?
    return false if @request.completed?
    return true
  end

  def update?
    edit?
  end

  def destroy?
    request.requester == user && !request.completed?
  end

  def manage?
    request.requester == user
  end
end