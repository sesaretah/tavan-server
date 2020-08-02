class ActivitySerializer < ActiveModel::Serializer
    attributes  :series

    def series   
      #Rails.logger.info '********'
      #Rails.logger.info Visit.where(visitable_type: object.class.name, visitable_id: object.id).group('created_at::date').count
      visits =  Visit.where('visitable_type = ? AND visitable_id = ? AND  created_at > ? ', object.class.name, object.id, 20.days.ago).group('created_at::date').count
      #if visits > 0
        return {title: object.title, data: visits}
     # end
    end
  end
  