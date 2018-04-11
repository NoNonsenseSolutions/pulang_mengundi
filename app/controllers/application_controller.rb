class ApplicationController < ActionController::Base
  include SessionsHelper
  include Pundit
  before_action :authenticate_user!

end
