class V1::TagsController < ApplicationController

  def index
    tags = Tag.all
    render json: { data: ActiveModel::SerializableResource.new(tags,  each_serializer: TagSerializer ).as_json, klass: 'Tag' }, status: :ok
  end

  def search
    if !params[:q].blank?
      tags = Tag.search params[:q], star: true
      render json: { data: ActiveModel::SerializableResource.new(tags,  each_serializer: TagSerializer ).as_json, klass: 'Tag' }, status: :ok
    else 
      render json: { data: [], klass: 'Tag' }, status: :ok
    end
  end
  

  def show
    @tag = Tag.find(params[:id])
    render json: { data: TagSerializer.new(@tag).as_json,  klass: 'Tag' }, status: :ok
  end

  def create
    @tag = Tag.new(tag_params)
    @tag.user_id = current_user.id
    if @tag.save
      render json: { data: TagSerializer.new(@tag).as_json, klass: 'Tag' }, status: :ok
    end
  end

  def update
    @tag = current_user.tag
    if @tag.update_attributes(tag_params)
      render json: { data: TagSerializer.new(@tag).as_json, klass: 'Tag' }, status: :ok
    end
  end


  def tag_params
    params.require(:tag).permit!
  end
end
