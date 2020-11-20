class V1::SurveillancesController < ApplicationController

 
  def show
    @surveillance = Surveillance.find(params[:id])
    render json: { data: SurveillanceSerializer.new(@surveillance).as_json, klass: 'Surveillance' }, status: :ok
  end 

  def index
    surveillances = Surveillance.all
    render json: { data: ActiveModel::SerializableResource.new(surveillances, scope: {user_id: current_user.id},  each_serializer: SurveillanceSerializer ).as_json, klass: 'Surveillance' }, status: :ok
  end

  def create
    @surveillance = Surveillance.new(surveillance_params)
    @surveillance.user_id =  current_user.id
    if @surveillance.save
      @surveillance.screen_cast.attach(params[:file])
      render json: { data:  SurveillanceSerializer.new(@surveillance).as_json}, status: :ok
    end
  end

  def destroy
    @surveillance = Surveillance.find(params[:id])
    if @surveillance.destroy
      render json: { data: @surveillance, klass: 'Surveillance' }, status: :ok
    else
      render json: { data: @surveillance.errors.full_messages  }, status: :ok
    end
  end

  def surveillance_params
    params.require(:surveillance).permit!
  end

end
