class ApplicationController < ActionController::Base
  include ApplicationHelper
  include Pundit
  before_action :authenticate_user!

end
