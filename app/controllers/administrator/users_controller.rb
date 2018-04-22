module Administrator
  class UsersController < Administrator::ApplicationController
    def index
      @query = Administrator::UsersQuery.new params: params
      @users = @query.results
    end

    def update
      @user = User.find_by(id: params[:id])
      respond_to do |format|
        format.json { 
          if @user.update(user_params)
            render json: { message: @user }, status: :accepted
          else
            render json: { message: @user.errors.full_messages.join("; ") }, status: :bad_request 
          end
        }
      end
    end

    private
      def user_params
        params
          .require(:user)
          .permit(:ic, :flagged)
      end
  end
end
