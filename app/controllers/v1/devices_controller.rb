class V1::DevicesController < ApplicationController


  def create
    @device = Device.new(device_params)
    @device.user_id = current_user.id
    if @device.save
      render json: { data:  DeviceSerializer.new(@device).as_json}, status: :ok
    end
  end

  def destroy
    @device = Device.find(params[:id])
    if @device.destroy
      render json: { data: @device, klass: 'Device' }, status: :ok
    else
      render json: { data: @device.errors.full_messages  }, status: :ok
    end
  end

  def device_params
    params.require(:device).permit!
  end

end
