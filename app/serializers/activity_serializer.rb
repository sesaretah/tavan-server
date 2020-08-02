class ActivitySerializer < ActiveModel::Serializer
    attributes  :series

    def series   
      #Rails.logger.info '********'
      #Rails.logger.info Visit.where(visitable_type: object.class.name, visitable_id: object.id).group('created_at::date').count
       return {title: object.title, data: Visit.where(visitable_type: object.class.name, visitable_id: object.id).group('created_at::date').count}
    end
  end
  