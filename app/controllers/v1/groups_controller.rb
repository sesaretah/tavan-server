class V1::GroupsController < ApplicationController

  def index
    groups = current_user.groups.order('created_at DESC')
    render json: { data: ActiveModel::SerializableResource.new(groups, user_id: current_user.id,  each_serializer: GroupSerializer ).as_json, klass: 'Group' }, status: :ok
  end


  def show
    @group = Group.find(params[:id])
    render json: { data:  GroupSerializer.new(@group, user_id: current_user.id).as_json, klass: 'Group'}, status: :ok
  end

  def abilities
    @group = Group.find(params[:id])
    @group.add_ability(params[:ability_title], params[:ability_value])
    render json: { data:  GroupSerializer.new(@group, user_id: current_user.id).as_json, klass: 'Group'}, status: :ok
  end

  def remove_ability
    @group = Group.find(params[:id])
    render json: { data:  GroupSerializer.new(@group, user_id: current_user.id).as_json, klass: 'Group'}, status: :ok
  end

  def create
    @group = Group.new(group_params)
    @group.user_id = current_user.id
    if @group.save
      @group.add_grouping(params[:grouping])
      render json: { data: GroupSerializer.new(@group).as_json, klass: 'Group' }, status: :ok
    end
  end

  def update
    @group = Group.find(params[:id])
    if @group.update_attributes(group_params)
      @group.add_grouping(params[:grouping])
      render json: { data: GroupSerializer.new(@group, user_id: current_user.id).as_json, klass: 'Group' }, status: :ok
    else
      render json: { data: @group.errors.full_messages  }, status: :ok
    end
  end

  def destroy
    @group = Group.find(params[:id])
    if @group.destroy
      render json: { data: 'OK'}, status: :ok
    end
  end

  def group_params
    params.require(:group).permit!
  end
end
