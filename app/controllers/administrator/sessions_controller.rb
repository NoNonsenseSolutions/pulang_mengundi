module Administrator
  class SessionsController < Devise::SessionsController
    layout 'admin/application'

    skip_before_action :authenticate_user!
  end
end
