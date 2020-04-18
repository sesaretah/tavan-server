class V1::TodoesController < ApplicationController

  def index
    todos = Todo.all.order('title DESC')
    render json: { data: ActiveModel::SerializableResource.new(todos, user_id: current_user.id,  each_serializer: TodoSerializer ).as_json, klass: 'Todo' }, status: :ok
  end

  def search
    if !params[:q].blank?
      todo = Todo.search params[:q], star: true
      render json: { data: ActiveModel::SerializableResource.new(status,  each_serializer: TodoSerializer ).as_json, klass: 'Todo' }, status: :ok
    else 
      render json: { data: [], klass: 'Todo' }, status: :ok
    end
  end

  def show
    @todo = Todo.find(params[:id])
    render json: { data:  TodoSerializer.new(@todo, user_id: current_user.id).as_json, klass: 'Todo'}, status: :ok
  end

  def create
    @todo = Todo.new(status_params)
    @todo.user_id = current_user.id
    if @todo.save
      render json: { data: TodoSerializer.new(@status).as_json, klass: 'Todo' }, status: :ok
    end
  end

  def update
    @todo = Todo.find(params[:id])
    if @todo.update_attributes(status_params)
      render json: { data: TodoSerializer.new(@todo, user_id: current_user.id).as_json, klass: 'Todo' }, status: :ok
    else
      render json: { data: @todo.errors.full_messages  }, status: :ok
    end
  end

  def destroy
    @todo = Todo.find(params[:id])
    if @todo.destroy
      render json: { data: 'OK'}, status: :ok
    end
  end

  def todo_params
    params.require(:todo).permit!
  end
end
