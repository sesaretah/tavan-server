class WorkEventSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :title, :date, :color

  def date
    object.deadline.in_time_zone("Tehran") if object.deadline
  end

  def color
    colors = ['#FFA07A','#F08080','#8B0000','#FF4500','#F0E68C','#7FFF00','#808000','#6B8E23','#66CDAA','#008080','#00BFFF','#000080','#483D8B','#DA70D6','	#8B008B','#FF69B4','#C71585','#696969']
    return colors[rand(1..15)]
  end

end
