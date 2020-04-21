class CommentSerializer < ActiveModel::Serializer
  attributes :id, :content, :created_at, :profile, :editable
  def profile 
     ProfileSerializer.new(object.profile).as_json
  end 

  def editable
    flag = false
    if scope && scope[:user_id]
      user = User.find(scope[:user_id])
      flag =  true if object.user_id == user.id
      role = object.commentable.user_role(user) if user
      access = object.commentable.access(role) if role
      flag =  true if access && access.include?('edit') 
      return flag
    end
  end
end
