class V1::UploadsController < ApplicationController


  def create
    @upload = Upload.new(upload_params)
    if @upload.save
      @upload.doc.attach(params[:file])
      render json: { data:  UploadSerializer.new(@upload).as_json}, status: :ok
    end
  end

  def destroy
    @upload = Upload.find(params[:id])
    if @upload.destroy
      render json: { data: @upload, klass: 'Upload' }, status: :ok
    else
      render json: { data: @upload.errors.full_messages  }, status: :ok
    end
  end

  def upload_params
    params.require(:upload).permit!
  end

end
