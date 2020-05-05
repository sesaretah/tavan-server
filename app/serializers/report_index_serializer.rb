class ReportIndexSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :title, :content,  :creation_date
  belongs_to :profile,  serializer: ProfileSerializer

  def content
    object.send(:content).to_s
  end

  def creation_date
    object.updated_at.in_time_zone("Tehran") if object.updated_at
  end

end
