class TagSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :title, :confirmed, :editable, :confirmable
  belongs_to :user,  serializer: UserSerializer

  def editable
    flag = false
    if scope && scope[:user_id]
      user = User.find_by_id(scope[:user_id])
      flag =  true if !user.blank? && object.user_id == user.id
      flag =  true if !user.blank? && user.has_ability('change_tags')
    end
    return flag
  end

  def confirmable
    flag = false
    if scope && scope[:user_id]
      user = User.find_by_id(scope[:user_id])
      flag =  true if !user.blank? && user.has_ability('confirm_tags')
    end
    return flag
  end
end
