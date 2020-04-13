class V1::TasksController < ApplicationController
  before_action :record_visit, only: [:show]
  
  def index
    tasks = Task.order('deadline DESC').all
    render json: { data: ActiveModel::SerializableResource.new(tasks, user_id: current_user.id,  each_serializer: TaskSerializer, scope: {user_id: current_user.id} ).as_json, klass: 'Task' }, status: :ok
  end

  def add_participants
    @task = Task.find(params[:id])
    @task.add_participant(params[:profile_id])
    render json: { data: TaskSerializer.new(@task).as_json, klass: 'Task' }, status: :ok
  end

  def change_status
    @task = Task.find(params[:id])
    @task.status_id = params[:status_id]
    @task.save
    render json: { data: TaskSerializer.new(@task).as_json, klass: 'Task' }, status: :ok
  end

  def remove_participants
    @task = Task.find(params[:id])
    @task.remove_participant(params[:profile_id])
    render json: { data: TaskSerializer.new(@task).as_json, klass: 'Task' }, status: :ok
  end


  def show
    @task = Task.find(params[:id])
    render json: { data:  TaskSerializer.new(@task, user_id: current_user.id, scope: {user_id: current_user.id}).as_json, klass: 'Task'}, status: :ok
  end

  def create
    @task = Task.new(task_params)
    @task.user_id = current_user.id
    if @task.save
      render json: { data: TaskSerializer.new(@task).as_json, klass: 'Task' }, status: :ok
    end
  end

  def update
    @task = Task.find(params[:id])
    @task.user_id = current_user.id
    if @task.update_attributes(task_params)
      render json: { data: TaskSerializer.new(@task, user_id: current_user.id).as_json, klass: 'Task' }, status: :ok
    else
      render json: { data: @task.errors.full_messages  }, status: :ok
    end
  end

  def destroy
    @task = Task.find(params[:id])
    if @task.destroy
      render json: { data: 'OK'}, status: :ok
    end
  end

  def task_params
    params.require(:task).permit!
    #params.permit!
  end
end
