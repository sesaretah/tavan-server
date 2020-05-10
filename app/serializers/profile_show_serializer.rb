class ProfileShowSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :name, :surename, :fullname, :bio,  :avatar, 
              :last_login,  :experties, :the_tasks, :the_works

  belongs_to :user

  def last_login
    #object.user.last_sign_in_at
  end

  def bio
    if object.bio.blank? 
      return ""
    else 
      object.bio
    end
  end

  def the_tasks
    if scope && scope[:user_id]
      user = User.find_by_id(scope[:user_id])
      tasks = Task.user_tasks(user) if user 
      ActiveModel::SerializableResource.new(tasks,  each_serializer: TaskIndexSerializer, scope: {user_id: scope[:user_id]} ).as_json if tasks
    end
  end

  def the_works
    if scope && scope[:user_id]
      user = User.find_by_id(scope[:user_id])
      works = Work.user_works(user) if user 
      ActiveModel::SerializableResource.new(works,  each_serializer: WorkIndexSerializer, scope: {user_id: scope[:user_id]} ).as_json if works
    end
  end
  


  def avatar
    if object.avatar.attached?
      Rails.application.routes.default_url_options[:host] + rails_blob_url(object.avatar, only_path: true)
    else
      Rails.application.routes.default_url_options[:host] + "/images/default.png"
    end
  end
end
