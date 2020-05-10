class V1::ReportsController < ApplicationController

  def index
    reports = Report.all.order('updated_at DESC').paginate(page: params[:page], per_page: 6)
    render json: { data: ActiveModel::SerializableResource.new(reports, user_id: current_user.id,  each_serializer: ReportSerializer ).as_json, klass: 'Report' }, status: :ok
  end

  def search
    if !params[:q].blank?
      reports = Report.search params[:q], star: true, page: params[:page], per_page: 6
    else 
      reports = Report.paginate(page: params[:page], per_page: 6)
    end
    render json: { data: ActiveModel::SerializableResource.new(reports,  each_serializer: ReportSerializer ).as_json, klass: 'Report' }, status: :ok
  end


  def show
    @report = Report.find(params[:id])
    params[:page].blank? ? @page = 1 : @page = params[:page]
    if valid_show_report?
      render json: { data:  ReportSerializer.new(@report, user_id: current_user.id, page: @page).as_json, klass: 'Report'}, status: :ok
    else 
      render json: { data: [], klass: 'Report'}, status: :ok
    end
  end

  def create
    @report = Report.new(report_params)
    @report.user_id = current_user.id
    if valid_report? && @report.save
      render json: { data: ReportSerializer.new(@report).as_json, klass: 'Report' }, status: :ok
    end
  end

  def update
    @report = Report.find(params[:id])
    if valid_report? && @report.update_attributes(report_params)
      render json: { data: ReportSerializer.new(@report, user_id: current_user.id).as_json, klass: 'Report' }, status: :ok
    else
      render json: { data: @report.errors.full_messages  }, status: :ok
    end
  end

  def destroy
    @report = Report.find(params[:id])
    if @report.destroy
      render json: { data: 'OK'}, status: :ok
    end
  end

  def valid_report?
    if @report.work
      valid = is_valid?(@report.work, 'reports') 
    else 
      valid = is_valid?(@report.task, 'reports')
    end
    return valid
  end

  def valid_show_report?
    if @report.work
      valid = is_valid?(@report.work, 'view_reports') 
    else 
      valid = is_valid?(@report.task, 'view_reports')
    end
    return valid
  end

  def report_params
    params.require(:report).permit!
  end
end
