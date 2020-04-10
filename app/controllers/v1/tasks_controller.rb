class V1::TasksController < ApplicationController

  def index
    tasks = Task.order('deadline DESC').all
    render json: { data: ActiveModel::SerializableResource.new(tasks, user_id: current_user.id,  each_serializer: TaskSerializer ).as_json, klass: 'Task' }, status: :ok
  end

  def add_participants
    @task = Task.find(params[:id])
    @task.add_participant(params[:profile_id])
    render json: { data: TaskSerializer.new(@task).as_json, klass: 'Task' }, status: :ok
  end

  def remove_participants
    @task = Task.find(params[:id])
    @task.remove_participant(params[:profile_id])
    render json: { data: TaskSerializer.new(@task).as_json, klass: 'Task' }, status: :ok
  end


  def show
    @task = Task.find(params[:id])
    render json: { data:  TaskSerializer.new(@task, user_id: current_user.id).as_json, klass: 'Task'}, status: :ok
  end

  def create
    @task = Task.new(task_params)
    @task.user_id = current_user.id
    #@task.deadline = JalaliDate.new(params[:deadline].to_datetime).to_g
    #@task.start = JalaliDate.new(params[:start].to_datetime).to_g
    if @task.save
      @task.share(params[:channel_id]) if !params[:channel_id].blank?
      render json: { data: TaskSerializer.new(@task).as_json, klass: 'Task' }, status: :ok
    end
  end

  def update
    @task = Task.find(params[:id])
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
  end
end
