class StatusSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :title, :the_color
  
  def the_color
    if !object.color.blank?
      object.color
    else 
      '#fff'
    end
  end
end
