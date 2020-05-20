class StatusChangeSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :statusable_type_pl, :statusable_id, :current_status, :prev_status, :profile, :title

  def statusable_type_pl
    object.statusable_type.downcase.pluralize
  end
  def profile 
    ProfileSerializer.new(object.user.profile).as_json
  end 

  def current_status
    object.status if object.status
  end

  def title
    object.statusable.title if object.statusable
  end

  def prev_status
    object.prev_status.status if object.prev_status && object.prev_status.status
  end
end
