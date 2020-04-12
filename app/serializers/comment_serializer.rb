class CommentSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :content, :created_at, :profile
  def profile 
     ProfileSerializer.new(object.profile).as_json
  end 
end
