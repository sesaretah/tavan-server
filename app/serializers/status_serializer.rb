class StatusSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :title, :the_color, :confirmed, :editable, :confirmable
  
  def the_color
    if !object.color.blank?
      object.color
    else 
      '#fff'
    end
  end

  def editable
    flag = false
    if scope && scope[:user_id]
      user = User.find_by_id(scope[:user_id])
      flag =  true if !user.blank? && object.user_id == user.id
      flag =  true if !user.blank? && user.has_ability('change_statuses')
    end
    return flag
  end

  def confirmable
    flag = false
    if scope && scope[:user_id]
      user = User.find_by_id(scope[:user_id])
      flag =  true if !user.blank? && user.has_ability('confirm_statuses')
    end
    return flag
  end
end
