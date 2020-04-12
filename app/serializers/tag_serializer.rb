class TagSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :title
  belongs_to :user,  serializer: UserSerializer

end
