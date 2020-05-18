class ReportSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :title, :draft, :content, :attachments, :the_work, :the_task, :creation_date, :the_comments, :user_access
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
        result << {id: upload.id, link: Rails.application.routes.default_url_options[:host] + rails_blob_url(upload.doc, only_path: true), filename: upload.doc.blob.filename}
      end
    end
    return result
  end

  def the_comments
    if scope && scope[:user_id]
      ActiveModel::SerializableResource.new(object.comments,  each_serializer: CommentSerializer, scope: {user_id: scope[:user_id]} ).as_json
    end
  end

  def the_task
    object.task if object.task
  end

  def the_work
    object.work if object.work
  end

  def user_access
    access = []
    if scope && scope[:user_id]
      user = User.find(scope[:user_id])
      role = object.user_role(user)
      access = object.access(role)
    end
    access = ['view'] if role != 'Creator' && object.archived
    access = ['view', 'edit'] if role == 'Creator' && object.archived
    return access
  end

  def creation_date
    object.updated_at.in_time_zone("Tehran") if object.updated_at
  end

end
