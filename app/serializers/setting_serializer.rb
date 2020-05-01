class SettingSerializer < ActiveModel::Serializer
  attributes :id, :notification_setting
  belongs_to :user

end
