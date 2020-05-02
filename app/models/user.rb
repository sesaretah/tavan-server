class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable
  has_one :profile
  after_create :set_setting

  has_many :actuals, :dependent => :destroy
  has_many :metas, through: :actuals
  has_many :tasks
  has_many :statuses
  has_many :tags
  has_many :notifications
  has_many :todos
  has_many :time_sheets
  has_many :devices
  has_many :groups
  has_one :setting
  
  def set_setting
    setting = Setting.create(user_id: self.id)
    setting.notification_setting = []
    setting.notification_setting['add_comments_to_tasks_email']  = true
    setting.notification_setting['add_comments_to_tasks_push']  = true
    setting.notification_setting['add_comments_to_works_email']  = true
    setting.notification_setting['add_comments_to_works_push']  = true
    setting.notification_setting['add_involvement_to_tasks_email'] = true
    setting.notification_setting['add_involvement_to_tasks_push'] = true
    setting.notification_setting['add_involvement_to_works_email'] = true
    setting.notification_setting['add_involvement_to_works_push'] = true
    setting.notification_setting['change_status_tasks_email'] = true
    setting.notification_setting['change_status_tasks_push'] = true
    setting.notification_setting['change_status_works_email'] = true
    setting.notification_setting['change_status_works_push'] = true
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
