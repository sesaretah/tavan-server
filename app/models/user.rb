class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable
  has_one :profile
  after_create :set_setting

  has_many :actuals, :dependent => :destroy
  has_many :metas, through: :actuals
  has_many :tasks, :dependent => :destroy
  has_many :statuses, :dependent => :destroy
  has_many :tags, :dependent => :destroy
  has_many :notifications, :dependent => :destroy
  has_many :todos, :dependent => :destroy
  has_many :time_sheets, :dependent => :destroy
  has_many :devices, :dependent => :destroy
  has_many :groups, :dependent => :destroy
  has_one :setting, :dependent => :destroy
  
  def set_setting
    setting = Setting.create(user_id: self.id)
    pre = {
      'add_comments_to_tasks_email' => true,
      'add_comments_to_tasks_push'  => true,
      'add_comments_to_works_email' => true,
      'add_comments_to_works_push'  => true,
      'add_involvement_to_tasks_email' => true,
      'add_involvement_to_tasks_push' => true,
      'add_involvement_to_works_email' => true,
      'add_involvement_to_works_push' => true,
      'change_status_tasks_email' => true,
      'change_status_tasks_push' => true,
      'change_status_works_email' => true,
      'change_status_works_push' => true
    }
    setting.notification_setting = pre
    setting.save
  end
  def assign(role_id)
    self.assignments = [] if self.assignments.blank?
    self.assignments << role_id
    self.save
  end

  def unassign(role_id)
    self.assignments -= [role_id] if !self.assignments.blank?
    self.save
  end

  def selected_role
    Role.find_by_id(self.current_role_id)
  end

  def ability
    self.selected_role.ability if self.selected_role
  end

  def has_ability(ab)
    flag = false
    if !self.selected_role.blank? && !self.selected_role.ability.blank?
      for a in self.selected_role.ability
        flag = true if a['title'] == ab
      end
    end
    return flag
  end

  def notify_user
    code = rand(10 ** 6).to_s.rjust(6,'0')  
    self.last_code = code
    self.last_code_datetime = DateTime.now
    self.last_login = DateTime.now
    self.save
    VerificationsMailer.notify_email(self.id, code).deliver_later
  end

  def self.verify(code)
    user = self.where('last_code = ? AND last_code_datetime > ?', code, 10.minutes.ago).first
  end


  
end
