class RequestPolicy
  attr_reader :user, :request

  def initialize(user, request)
    @user = user
    @request = request
  end

  def edit?
    request.requester == user && !request.pledges.exists?
  end

  def update?
    edit?
  end

  def manage?
    request.requester == user
  end
end