class ReportIndexSerializer < ActiveModel::Serializer
  cache key: "report_index_serializer", expires_in: 3.hours

  attributes :id, :title, :content,  :creation_date
  belongs_to :profile,  serializer: ProfileSerializer

  def content
    object.send(:content).to_s
  end

  def creation_date
    object.updated_at.in_time_zone("Tehran") if object.updated_at
  end

end
