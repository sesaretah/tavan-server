class V1::TimeSheetsController < ApplicationController

  def index
    mine_time_sheets = current_user.time_sheets.order('sheet_date DESC').paginate(page: page, per_page: 20)
    related_time_sheets = TimeSheet.related(current_user, page)
    render json: { data: {mine: jsoner(mine_time_sheets), related: jsoner(related_time_sheets) }, klass: 'TimeSheet' }, status: :ok
  end

  def mine
    mine_time_sheets = current_user.time_sheets.order('sheet_date DESC').paginate(page: page, per_page: 20)
    render json: { data: jsoner(mine_time_sheets), klass: 'TimeSheetMine' }, status: :ok
  end

  def related
    related_time_sheets = TimeSheet.related(current_user, page)
    render json: { data: jsoner(related_time_sheets), klass: 'TimeSheetRelated' }, status: :ok
  end

  def search
    if !params[:q].blank?
      time_sheets = TimeSheet.search params[:q], star: true
      render json: { data: ActiveModel::SerializableResource.new(time_sheets,  each_serializer: TimeSheetSerializer , scope: {user_id: current_user.id}).as_json, klass: 'TimeSheet' }, status: :ok
    else 
      render json: { data: [], klass: 'TimeSheet' }, status: :ok
    end
  end

  def search_associations
    arr = TimeSheet.search_association(params[:q])
    render json: { data: arr, klass: 'TimeSheet' }, status: :ok
  end
  

  def show
    @time_sheet = TimeSheet.find(params[:id])
    render json: { data: TimeSheetSerializer.new(@time_sheet, scope: {user_id: current_user.id}).as_json,  klass: 'TimeSheet' }, status: :ok
  end

  def create
    @time_sheet = TimeSheet.new(time_sheet_params)
    @time_sheet.user_id = current_user.id
    if @time_sheet.save
      @time_sheet.append_date(params)
      @time_sheet.add_involvements(params[:involvements])
      render json: { data: TimeSheetSerializer.new(@time_sheet, scope: {user_id: current_user.id}).as_json, klass: 'TimeSheet' }, status: :ok
    end
  end

  def update
    @time_sheet = TimeSheet.find(params[:id])
    if @time_sheet.update_attributes(time_sheet_params)
      @time_sheet.append_date(params)
      @time_sheet.add_involvements(params[:involvements])
      render json: { data: TimeSheetSerializer.new(@time_sheet, scope: {user_id: current_user.id}).as_json, klass: 'TimeSheet' }, status: :ok
    end
  end

  def jsoner(h)
    ActiveModel::SerializableResource.new(h,  each_serializer: TimeSheetSerializer, scope: {user_id: current_user.id} ).as_json
  end

  def page
    if params[:page].blank?
      @page = 1
    else 
      @page = params[:page]
    end
    return @page
  end


  def time_sheet_params
    params.require(:time_sheet).permit!
  end
end
