class SurveillanceSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :link

  def link
    if object.screen_cast.attached?
      Rails.application.routes.default_url_options[:host] + rails_blob_url(object.screen_cast, only_path: true)
    end
  end
end
