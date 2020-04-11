class V1::StatusesController < ApplicationController

  def index
    statuses = Status.all.order('title DESC')
    render json: { data: ActiveModel::SerializableResource.new(statuses, user_id: current_user.id,  each_serializer: StatusSerializer ).as_json, klass: 'Status' }, status: :ok
  end

  def search
    if !params[:q].blank?
      status = Status.search params[:q], star: true
      render json: { data: ActiveModel::SerializableResource.new(status,  each_serializer: StatusSerializer ).as_json, klass: 'Status' }, status: :ok
    else 
      render json: { data: [], klass: 'Status' }, status: :ok
    end
  end

  def show
    @status = Status.find(params[:id])
    render json: { data:  StatusSerializer.new(@status, user_id: current_user.id).as_json, klass: 'Status'}, status: :ok
  end

  def create
    @status = Status.new(status_params)
    @status.user_id = current_user.id
    if @status.save
      @status.share(params[:channel_id]) if !params[:channel_id].blank?
      render json: { data: StatusSerializer.new(@status).as_json, klass: 'Status' }, status: :ok
    end
  end

  def update
    @status = Status.find(params[:id])
    if @status.update_attributes(status_params)
      render json: { data: StatusSerializer.new(@status, user_id: current_user.id).as_json, klass: 'Status' }, status: :ok
    else
      render json: { data: @status.errors.full_messages  }, status: :ok
    end
  end

  def destroy
    @status = Status.find(params[:id])
    if @status.destroy
      render json: { data: 'OK'}, status: :ok
    end
  end

  def status_params
    params.require(:status).permit!
  end
end
