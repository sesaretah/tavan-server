class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable
  has_one :profile

  has_many :actuals, :dependent => :destroy
  has_many :metas, through: :actuals
  has_many :tasks
  has_many :statuses
  has_many :tags

  def assign(role_id)
    self.assignments = [] if self.assignments.blank?
    self.assignments << role_id
    self.save
  end

  def unassign(role_id)
    self.assignments -= [role_id] if !self.assignments.blank?
    self.save
  end

  
end
