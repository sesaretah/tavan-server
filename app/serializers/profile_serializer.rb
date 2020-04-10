class ProfileSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :name, :surename, :fullname, :bio,  :avatar, :metas, :last_login,  :experties

  belongs_to :user

  def last_login
    object.user.last_sign_in_at
  end

  def bio
    if object.bio.blank? 
      return ""
    else 
      object.bio
    end
  end
  
  def metas
    result = []
    #object.user.actuals.group_by(&:meta_id).each do |meta_id, actuals|
    #  meta = Meta.find(meta_id)
    for meta in Meta.all
      result << {meta: MetaSerializer.new(meta).as_json, actuals: ActiveModel::SerializableResource.new(meta.actuals,  each_serializer: ActualSerializer ).as_json}
    end
    return result
  end

  def avatar
    if object.avatar.attached?
      Rails.application.routes.default_url_options[:host] + rails_blob_url(object.avatar, only_path: true)
    else
      Rails.application.routes.default_url_options[:host] + "/images/default.png"
    end
  end
end
