# frozen_string_literal: true

module Administrator
  class UsersController < Administrator::ApplicationController
    def index
      @query = Administrator::UsersQuery.new params: params
      @users = @query.results
    end

    def edit
      @user = User.find(params[:id])
    end

    def update
      @user = User.find_by(id: params[:id])
      respond_to do |format|
        format.json do
          if @user.update(user_params)
            render json: { message: @user }, status: :accepted
          else
            render json: { message: @user.errors.full_messages.join('; ') }, status: :bad_request
          end
        end
        format.html do
          if @user.update(user_params)
            flash[:success] = 'Saved'
          else
            flash[:danger] = @user.errors.full_messages.join('; ')
          end
          redirect_back(fallback_location: [:edit, :administrator, @user])
        end
      end
    end

    private

    def user_params
      params
        .require(:user)
        .permit(:ic, :flagged, :verified_donor, :is_ic_verified, :name, :email).tap do |parameters|
          parameters[:ic_verified_at] = if parameters[:is_ic_verified].to_i.zero?
                                          nil
                                        else
                                          @user.ic_verified_at || Time.zone.now
                                        end
          parameters.delete(:is_ic_verified)

          parameters.delete(:ic) unless parameters[:ic].present?
        end
    end
  end
end
