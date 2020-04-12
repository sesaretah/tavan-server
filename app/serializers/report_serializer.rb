class ReportSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :title, :draft, :content, :attachments, :the_work, :the_task, :creation_date
  belongs_to :profile,  serializer: ProfileSerializer

  def content
    object.send(:content).to_s
  end

  def attachments
   # object.uploads
    result = []
    for u in object.uploads
      upload = Upload.find(u.id)
      if upload.doc.attached?
        result << {link: 'http://localhost:3001' + rails_blob_url(upload.doc, only_path: true), filename: upload.doc.blob.filename}
      end
    end
    return result
  end

  def the_task
    object.task if object.task
  end

  def the_work
    object.work if object.work
  end

  def creation_date
    object.updated_at.in_time_zone("Tehran") if object.updated_at
  end

end
