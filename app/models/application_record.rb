class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true



  def change_role(profile_id, role)
    profile = Profile.find_by_id(profile_id)
    involvement = user_involvement(profile.user)
    involvement.change_role(role) if involvement
  end

  def create_notification(type, profile)
    Notification.create(
      notifiable_id: self.id, notifiable_type: self.class.name, 
      notification_type: type, source_user_id: self.user_id, target_user_hash: self.id_to_hash,
      target_user_ids: self.owners , seen: false, custom_text: profile.fullname)
  end

  def id_to_hash
    hash = {}
    for id in self.owners
      hash["#{id}"] = 'true'
    end
    return hash
  end

  def add_involvement(profile_id, user)
    profile = Profile.find_by_id(profile_id)
    involvement = user_involvement(profile.user) if profile.user
    if !profile.blank? && profile.user && involvement.blank? && (profile.user.setting.blank? ||  profile.user.setting.blocked_list.blank? ||(!profile.user.setting.blocked_list.blank? && !profile.user.setting.blocked_list.include?(user.id)))
        self.involvements.create(user_id: profile.user_id, role: 'Observer', status: 'Requested')
        create_notification('AddInvolvement', profile)
    end
  end

  def remove_involvement(profile_id)
    profile = Profile.find_by_id(profile_id)
    involvement = user_involvement(profile.user)
    if !profile.blank? && profile.user && !involvement.blank?
        involvement.destroy
        create_notification('RemoveInvolvement', profile)
    end
  end


  def owners
    self.involvements.pluck(:user_id).uniq #- [self.user_id]
  end


  def add_admin
    self.involvements.create(user_id: self.user_id, role: 'Creator', status: 'Accepted')
  end


  def user_role(user) 
    involvement = user_involvement(user)
    involvement.role if involvement
  end

  def user_involvement(user)
    self.involvements.where(user_id: user.id).first
  end

  def change_status(status_id, user)
    if !user.profile.blank?
      self.status_id = status_id
      StatusChange.create(statusable_type: self.class.name, statusable_id: self.id, status_id: status_id, user_id: user.id)
      create_notification('ChangeStatus', user.profile)
    end
  end




end
