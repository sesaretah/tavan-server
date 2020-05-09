class TaskIndexSerializer < ActiveModel::Serializer
  attributes :id, :title, :details, :the_tags,
             :is_public, :report_alert, :comment_alert, :deadline_alert, :ability


  def is_public
    object.public
  end

  def comment_alert
    if scope && scope[:user_id]
      user = User.find(scope[:user_id])
      return Comment.comments_since(user, object)
    end
  end

  def ability 
    if scope && scope[:user_id]
      user = User.find_by_id(scope[:user_id])
      user.ability if user
    end
  end


  def deadline_alert
    if scope && scope[:user_id]
      user = User.find(scope[:user_id])
      return Work.deadline_since(user, object)
    end
  end

  def report_alert
    if scope && scope[:user_id]
      user = User.find(scope[:user_id])
      return Report.reports_since(user, object)
    end
  end



  def the_tags
    result = []
    for tag in object.taggings
      result << {title: tag.title, id: tag.id}
    end
    return result
  end

  def status
    object.status if object.status
  end
end
