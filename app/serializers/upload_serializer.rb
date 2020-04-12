class UploadSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :link

  def link
    if object.doc.attached?
      'http://localhost:3001' + rails_blob_url(object.doc, only_path: true)
    end
  end
end
