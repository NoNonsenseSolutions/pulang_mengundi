class ReportsController < ApplicationController
  def create
    reported = User.find(params[:user_id])
    reporter = current_user
    @report = Report.new report_params.merge({reporter: reporter, reported: reported})
    if @report.save
      flash[:success] = t('.success')
    else
      flash[:danger] = @report.errors.full_messages.join('; ')
    end
    redirect_back(fallback_location: root_path)
  end

  private
    def report_params
      params.require(:report).permit(:reason)
    end
end