# frozen_string_literal: true

class TermsAndConditionsController < ApplicationController
  skip_before_action :prompt_tnc, only: %i[show update]
  def show
    @user = current_user
  end

  def update
    @user = current_user
    @user.attributes = terms_and_conditions_params
    if @user.save(context: :tnc_prompt)
      redirect_back_or(root_path)
    else
      flash[:danger] = 'To continue using our service, please agree to the terms and conditions'
      redirect_to terms_and_conditions_path
    end
  end

  private

  def terms_and_conditions_params
    params.require(:user).permit(:read_terms)
  end
end
