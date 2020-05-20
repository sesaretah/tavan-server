class V1::WorksController < ApplicationController
  before_action :record_visit, only: [:show, :add_involvements, :change_role,:change_status, :remove_involvements]
  
  def index
    works = Work.newest_works(current_user)
    render json: { data: ActiveModel::SerializableResource.new(works, scope: {user_id: current_user.id},  each_serializer: WorkIndexSerializer ).as_json, klass: 'Work' }, status: :ok
  end

  def change_role
    @work = Work.find(params[:id])
    @work.change_role(params[:profile_id], params[:role]) if is_valid?(@work , 'involvements')
    render json: { data: WorkSerializer.new(@work, scope: {user_id: current_user.id} ).as_json, klass: 'Work' }, status: :ok
  end


  def add_involvements
    @work = Work.find(params[:id])
    @work.add_involvement(params[:profile_id], current_user) if is_valid?(@work , 'involvements')
    render json: { data: WorkSerializer.new(@work, scope: {user_id: current_user.id}).as_json, klass: 'Work' }, status: :ok
  end

  def change_status
    @work = Work.find(params[:id])
    @work.change_status(params[:status_id], current_user) if is_valid?(@work, 'statuses')
    @work.save 
    render json: { data: WorkSerializer.new(@work, scope: {user_id: current_user.id}).as_json, klass: 'Work' }, status: :ok
  end

  def remove_involvements
    @work = Work.find(params[:id])
    @work.remove_involvement(params[:profile_id]) if is_valid?(@work , 'involvements')
    render json: { data: WorkSerializer.new(@work, scope: {user_id: current_user.id}).as_json, klass: 'Work' }, status: :ok
  end


  def show
    @work = Work.find(params[:id])
    if is_valid?(@work, 'view')
      render json: { data:  WorkSerializer.new(@work, scope: {user_id: current_user.id}).as_json, klass: 'Work'}, status: :ok
    else 
      render json: { data:  [], klass: 'Work'}, status: :ok
    end
  end

  def create
    @work = Work.new(work_params)
    @work.user_id = current_user.id
    @work.append_time(params)
    if is_valid?(@work.task , 'works') && @work.save
      render json: { data: WorkSerializer.new(@work, scope: {user_id: current_user.id}).as_json, klass: 'Work' }, status: :ok
    end
  end

  def update
    @work = Work.find(params[:id])
    @work.user_id = current_user.id
    if is_valid?(@work.task , 'works') && @work.update_attributes(work_params)
      @work.append_time(params)
      @work.save
      render json: { data: WorkSerializer.new(@work, scope: {user_id: current_user.id}).as_json, klass: 'Work' }, status: :ok
    else
      render json: { data: @work.errors.full_messages  }, status: :ok
    end
  end

  def destroy
    @work = Work.find(params[:id])
    if is_valid?(@work, 'edit') &&  @work.destroy
      render json: { data: 'OK'}, status: :ok
    end
  end

  def work_params
    params.require(:work).permit!
    #params.permit!
  end
end
