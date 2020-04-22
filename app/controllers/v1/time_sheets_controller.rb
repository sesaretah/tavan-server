class V1::TimeSheetsController < ApplicationController

  def index
    time_sheets = TimeSheet.all
    render json: { data: ActiveModel::SerializableResource.new(time_sheets,  each_serializer: TimeSheetSerializer ).as_json, klass: 'TimeSheet' }, status: :ok
  end

  def search
    if !params[:q].blank?
      time_sheets = TimeSheet.search params[:q], star: true
      render json: { data: ActiveModel::SerializableResource.new(time_sheets,  each_serializer: TimeSheetSerializer ).as_json, klass: 'TimeSheet' }, status: :ok
    else 
      render json: { data: [], klass: 'TimeSheet' }, status: :ok
    end
  end
  

  def show
    @time_sheet = TimeSheet.find(params[:id])
    render json: { data: TimeSheetSerializer.new(@time_sheet).as_json,  klass: 'TimeSheet' }, status: :ok
  end

  def create
    @time_sheet = TimeSheet.new(time_sheet_params)
    @time_sheet.user_id = current_user.id
    if @time_sheet.save
      render json: { data: TimeSheetSerializer.new(@time_sheet).as_json, klass: 'TimeSheet' }, status: :ok
    end
  end

  def update
    @time_sheet = current_user.time_sheet
    if @time_sheet.update_attributes(time_sheet_params)
      render json: { data: TimeSheetSerializer.new(@time_sheet).as_json, klass: 'TimeSheet' }, status: :ok
    end
  end


  def time_sheet_params
    params.require(:time_sheet).permit!
  end
end
