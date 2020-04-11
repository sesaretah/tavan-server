class V1::WorksController < ApplicationController

  def index
    works = Work.order('deadline DESC').all
    render json: { data: ActiveModel::SerializableResource.new(works, user_id: current_user.id,  each_serializer: WorkSerializer ).as_json, klass: 'Work' }, status: :ok
  end

  def add_participants
    @work = Work.find(params[:id])
    @work.add_participant(params[:profile_id])
    render json: { data: WorkSerializer.new(@work).as_json, klass: 'Work' }, status: :ok
  end

  def change_status
    @work = Work.find(params[:id])
    @work.status_id = params[:status_id]
    @work.save
    render json: { data: WorkSerializer.new(@work).as_json, klass: 'Work' }, status: :ok
  end

  def remove_participants
    @work = Work.find(params[:id])
    @work.remove_participant(params[:profile_id])
    render json: { data: WorkSerializer.new(@work).as_json, klass: 'Work' }, status: :ok
  end


  def show
    @work = Work.find(params[:id])
    render json: { data:  WorkSerializer.new(@work, user_id: current_user.id).as_json, klass: 'Work'}, status: :ok
  end

  def create
    @work = Work.new(work_params)
    @work.user_id = current_user.id
    @work.append_time(params)
    if @work.save
      @work.share(params[:channel_id]) if !params[:channel_id].blank?
      render json: { data: WorkSerializer.new(@work).as_json, klass: 'Work' }, status: :ok
    end
  end

  def update
    @work = Work.find(params[:id])
    @work.user_id = current_user.id
    @work.append_time(params)
    if @work.save
      render json: { data: WorkSerializer.new(@work, user_id: current_user.id).as_json, klass: 'Work' }, status: :ok
    else
      render json: { data: @work.errors.full_messages  }, status: :ok
    end
  end

  def destroy
    @work = Work.find(params[:id])
    if @work.destroy
      render json: { data: 'OK'}, status: :ok
    end
  end

  def work_params
    params.require(:work).permit!
    #params.permit!
  end
end
